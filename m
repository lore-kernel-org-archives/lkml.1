Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbXHBRm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbXHBRm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758240AbXHBRmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:42:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49604 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbXHBRmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:42:19 -0400
Message-ID: <46B2174F.2070705@zytor.com>
Date: Thu, 02 Aug 2007 13:41:35 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: bbpetkov@yahoo.de
CC: Xudong Guan <xudong.guan@gmail.com>, linux-kernel@vger.kernel.org,
       Chuck Ebbert <cebbert@redhat.com>, michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.23-rc1: no setup signature found... SOLVED!
References: <20070729085059.GA10758@gollum.tnic> <20070729092402.GA2272@xguan-laptop> <20070729103706.GA16780@gollum.tnic> <46AC9B28.6060906@zytor.com> <20070729191528.GA5166@gollum.tnic> <46ADF02F.7010800@zytor.com> <20070730185359.GA4290@gollum.tnic> <46AE4E29.7060402@zytor.com> <20070801043835.GA4676@gollum.tnic> <46B09A57.8000403@zytor.com> <20070802051323.GA4152@gollum.tnic>
In-Reply-To: <20070802051323.GA4152@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> Hi,
> 
> now this is one of those cases where one tries to shoot a small fly with a
> nuclear missile. The first assumption that something was wrong with the kernel
> setup code was wrong and here's how i know:
> 
> The problem with my version of grub not hitting the breakpoint 0x90200 made me
> think that something might be messed up in the grub part of the boot sequence.
> Thus, i did the qemu simulation again and noticed on the initial boot screen of
> grub it saying "Grub version 0.91." However, you remember from a different post
> that the version of grub i have is the latest to be found in debian unstable,
> 0.97-29, so i thought that something has to be wrong with it and especially with all
> those grub stages binaries, in my case in /boot/grub, which grub-install setups.
> Checking their timestamps revealed that the files are from 2004 so i thought,
> well, these are OLD! :) After refreshing the grub installation and replacing
> the stages-binaries with the fresh ones, the kernel booted just fine :), here:
> 
> [boris@gollum:07:02:07:~:9994)->  uname -a
> Linux gollum 2.6.22-4fd06960f120e02e9abc802a09f9511c400042a5-12 #12 PREEMPT Thu Jul 26 18:08:34 CEST 2007 i686 GNU/Linux
> 
> so i guess the problem was with the ancient parts of a grub installation i had
> lying around which weren't replaced by the apt-get update process and somehow
> messed up newer grub versions. Anyway, in the end one still learns a lot while at it.
> 
> Thanks for your help.
> 

Very cool.  I actually suspected that, but I wanted to explore all 
avenues.  I'm glad this can be written off.

	-hpa
