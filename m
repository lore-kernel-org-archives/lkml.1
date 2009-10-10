Return-Path: <linux-kernel-owner+w=401wt.eu-S1761787AbZJJP5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761787AbZJJP5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbZJJP5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:57:05 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:19177 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761644AbZJJP5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:57:03 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=sFIEXyL5ArgA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8
 a=Pc8EArvC-NQjzRVdoXwA:9 a=sWpv_8VaoxB9_p1ZcR0A:7
 a=LLMBQxRRZVZBktIJBUCEEGPJAO8A:4 a=U62fhAwekXMA:10
From: "Thomas Fjellstrom" <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: MVSAS 1669:mvs_abort_task:rc= 5
Date: Sat, 10 Oct 2009 09:56:19 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-git2; KDE/4.3.2; x86_64; ; )
Cc: "linux-raid" <linux-raid@vger.kernel.org>,
       "linux-scsi" <linux-scsi@vger.kernel.org>
References: <200910091141.52303.tfjellstrom@shaw.ca>
In-Reply-To: <200910091141.52303.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910100956.19241.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri October 9 2009, Thomas Fjellstrom wrote:
> Hi,
> 
> I've been trying to get an AOC-SASLP-MV8 card (pcie x4 2 port SAS card) to
> work with linux for the past month or so. I've recently just RMAed my first
> card, and tested the new one under linux, and I see the same problems.
> 
> The very first time I made a new array off the controller, formated (with
>  xfs) and mounted the volume, it seemed to work. ioozone even seemed to run
>  for a while. Sadly after a few minutes I got a stream of mvs_abort_task
>  messages in dmesg, and any accesses to the volume, or any disks connected
>  to the controller lock up.
> 
> After that I updated my 2.6.31 kernel to 2.6.32-rc3-git2 off of kernel.org,
> and the volume fails to mount with the same mvs_abort_task messages.
> 
> I've attached my dmesg log from both attempts. dmesg1 is the first attempt,
> dmesg2 is the second attempt on the newer kernel.
> 
> I would really appreciate some help with this.
> 

I should also mention that if I attempt to remove any of the drives while the 
card is in a hung state, the entire machine locks up with the keyboard LEDs 
blinking.

This does seem to be a rather serious error.

If there is more I can do to help track down the problems, please let me know. 
I really need to get this to work (my current array is FULL, and may be 
showing signs of failure) as soon as possible.

I can pretty much wipe and reinstall everything at any point on this machine, 
update/install new kernels, etc. I just don't have a null modem cable atm to 
hook up a serial console to capture the errors on OOPSes.

Thanks.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
