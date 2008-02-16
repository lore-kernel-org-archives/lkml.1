Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYBPPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYBPPCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 10:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYBPPC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 10:02:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34935 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbYBPPC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 10:02:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B6FADB.1090203@s5r6.in-berlin.de>
Date: Sat, 16 Feb 2008 16:01:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 11/9 update] firewire: fw-sbp2: enforce a retry of __scsi_add_device
 if bus generation changed
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <47ACB449.3060200@s5r6.in-berlin.de> <tkrat.e02d667ba3320993@s5r6.in-berlin.de> <200802101336.57689.jwilson@redhat.com>
In-Reply-To: <200802101336.57689.jwilson@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote on 2008-02-10:
> Now *this* does the trick. I get the 'READ CAPACITY failed' as before, 
> then 'firewire_sbp2: fw1.0: error status: 0:4', followed by a new login and 
> SCSI probe, both of which are successful this time, disk is available for use 
> and all that good stuff.

FYI, I now committed this patch to linux1394-2.6.git after folding patch
 "firewire: fw-sbp2: retry login if scsi_device was offlined early" into it.
-- 
Stefan Richter
-=====-==--- --=- =----
http://arcgraph.de/sr/
