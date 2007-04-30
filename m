Return-Path: <linux-kernel-owner+w=401wt.eu-S1946805AbXD3VMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946805AbXD3VMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946824AbXD3VMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:12:05 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:49663 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946805AbXD3VMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:12:03 -0400
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 17:12:03 EDT
Date: Mon, 30 Apr 2007 13:51:00 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Stephen.Clark@seclark.us, Jeff Garzik <jeff@garzik.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
In-Reply-To: <20070430213127.49e4bd73@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0704301348060.31107@blackbox.fnordora.org>
References: <20070429161542.GA12501@havoc.gtf.org> <46364901.4000907@redhat.com>
 <46364C04.4050208@garzik.org> <46364FFA.9050500@seclark.us>
 <20070430213127.49e4bd73@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, Alan Cox wrote:

>> Yeah the kernel will boot but the hd performance is sh*t on my laptop. I
>> am running FC6 with
>> kernel 2.6.21 and without the combined_mode setting my disk performance
>> goes down to a
>> whopping 1.25mb/sec from 44mb/sec when I boot with combined_mode=libata.
>
> Then something is very wrong with the way you are setting it up, or the
> current code. Please post a dmesg booting with libata driving all your
> disks and it can get fixed before 2.6.22
>
> Do you happen to know how FC7test4 behaves on your box btw

I did the upgrade last night.  Drive performance was SLLOOWW.  When it 
came time to the reboot, I had a corrupted disk.  (Not certain if that was 
the fault of the upgrade.  I have to finish the fsck repairs first.) And 
this is with ext3.  Not good.

I have been seeing real bad driver performance on the latest FC6 kernel as 
well.

-- 
"Invoking the supernatural can explain anything, and hence explains nothing."
                   - University of Utah bioengineering professor Gregory Clark
