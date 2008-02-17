Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbYBQVIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbYBQVIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbYBQVIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:08:13 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:37231 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYBQVIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:08:12 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B8A232.9080605@s5r6.in-berlin.de>
Date: Sun, 17 Feb 2008 22:08:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] ieee1394: sbp2: fix rescan-scsi-bus
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>	 <tkrat.e66f8acfe9d89925@s5r6.in-berlin.de> <1203264186.3082.33.camel@localhost.localdomain> <47B875CA.8070900@s5r6.in-berlin.de>
In-Reply-To: <47B875CA.8070900@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Sun, 2008-02-17 at 14:57 +0100, Stefan Richter wrote:
>>> rescan-scsi-bus used to add SBP-2 targets which weren't there.

PS:  It probably wasn't clear:  rescan-scsi-bus.sh is *not* necessary
for sbp2 (under Linux 2.6, that is).  The patch merely prevents weird
things from happening if the user runs rescan-scsi-bus.sh on a 2.6 box
with sbp2 driven shosts present.
-- 
Stefan Richter
-=====-==--- --=- =---=
http://arcgraph.de/sr/
