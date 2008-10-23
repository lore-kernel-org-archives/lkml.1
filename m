Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYJWP1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYJWP1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYJWP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:27:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYJWP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:27:27 -0400
Message-ID: <490097BF.8050407@zytor.com>
Date: Thu, 23 Oct 2008 08:26:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Robert Moss <robert.von.moss@gmail.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Framebuffer issues in 2.6.26 with uvesafb and vesafb. Linux is
 about choice!
References: <6ffd69180810230054s3b6aff5y880a898c3fc66a37@mail.gmail.com> <20081023080459.GC5073@const.bordeaux.inria.fr> <6ffd69180810230421v1508664bgc6e454cde792154f@mail.gmail.com> <200810231322.15257.alistair@devzero.co.uk>
In-Reply-To: <200810231322.15257.alistair@devzero.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Thursday 23 October 2008 12:21:09 Robert Moss wrote:
>> I also want to note, that I downloaded 2.6.27.3 and compiled, with
>> CONFIG_FB_VESA=Y, and still get excactly the same response as from
>> 2.6.26
> 
> Useful info, and I checked your configs and they enable the right options. 
> Looks like you've found a real bug.
> 
> IIRC, a lot of real mode assembler (including the x86 vga/vesa stuff, iirc) 
> was rewritten a year or so ago, in C. This might have been the time that this 
> bug was introduced. I've added hpa to CC since I believe he was the author of 
> these changes.
> 
> (Summary of the original report is that vga= vesa mode selection seems to have 
> broken for Robert since at least 2.6.26, and after 2.6.24. From what I can see 
> he has the right vesafb options enabled.)
> 

That happend in 2.6.23 I believe, so that would be unrelated.

The best would be to bisect the regression.  The second best would be if 
he could run the "vesainfo" program from the Syslinux distribution (it's 
a pre-boot program that dumps information on the VESA stack).  The third 
best would be to set up Xorg to run the "vesa" driver, and send 
/var/log/Xorg.0.log.

	-hpa

