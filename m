Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXKDNUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXKDNUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 08:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbXKDNUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 08:20:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44363 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbXKDNT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 08:19:59 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472DC6DE.6050402@s5r6.in-berlin.de>
Date: Sun, 04 Nov 2007 14:19:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to
 boot: kernel BUG at include/linux/scatterlist.h:49!
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com> <472BA567.8040301@s5r6.in-berlin.de> <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com> <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk> <20071104084456.GJ28340@kernel.dk> <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com> <20071104130315.GL28340@kernel.dk>
In-Reply-To: <20071104130315.GL28340@kernel.dk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Chained sg lists will only be feed to a scsi host controller that
> enables chaining in its host template.
> 
> The fix looks fine though, it's just not a requirement or bug fix :-)

Good, then the sbp2 and fw-sbp2 patches can wait for 2.6.25.

Which criteria decide whether a SCSI low-level driver should enable
chained s/g lists?  The SBP-2 protocol supports s/g lists with up to
65535 entries.  The sbp2 and fw-sbp2 driver limit this currently to SG_ALL.
-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
