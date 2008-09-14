Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYINJWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYINJWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYINJWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:22:47 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46273 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYINJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:22:47 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48CCD7E9.50805@s5r6.in-berlin.de>
Date: Sun, 14 Sep 2008 11:22:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: time out in fw_core_remove_card
References: <tkrat.b3c43c8b09b72285@s5r6.in-berlin.de>
In-Reply-To: <tkrat.b3c43c8b09b72285@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> This allows "modprobe -r firewire-ohci" (or card unbinding in general)
> to proceed after 40 seconds even if there is a reference counting bug or
> other shutdown bug in upper layers.

Hmm, this doesn't work quite perfectly yet if there are userspace 
clients which keep a device open.  fw-cdev needs to be trained to let go 
of a device as gracefully as fw-sbp2 does nowadays.
-- 
Stefan Richter
-=====-==--- =--= -===-
http://arcgraph.de/sr/
