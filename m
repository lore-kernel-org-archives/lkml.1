Return-Path: <linux-kernel-owner+w=401wt.eu-S964950AbXG0Pv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964950AbXG0Pv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 11:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758871AbXG0Pvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 11:51:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105AbXG0Pvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 11:51:50 -0400
Message-ID: <46AA1494.5020709@redhat.com>
Date: Fri, 27 Jul 2007 11:51:48 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: bbpetkov@yahoo.de, Xudong Guan <xudong.guan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <46A8E3F9.5070809@zytor.com> <20070727013615.GC4570@gollum.tnic> <46A9753A.1010206@zytor.com>
In-Reply-To: <46A9753A.1010206@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2007 12:31 AM, H. Peter Anvin wrote:
> Borislav Petkov wrote:
>>> The absolute best would be if we could replicate this in simulation
>>> (Bochs or Qemu); this would make it very simple to debug.  Would you be
>>> willing to try to do that?
>> sure, will do, however i'll be busy at work/travelling tomorrow but as soon as i
>> get home i'll whip up my qemu and run the kernel in question in it. However,
>>  Xudong said that grub 0.97 boots just fine on his machine and i think it'll be
>>  better to debug this right on the bare hardware (i.e. my laptop) ...?
>>  Suggestions ?
> 
> If we can't reproduce the problem in simulation, that itself will tell
> us something very important.  If we *can* reproduce it in simulation, it
> will be vastly easier to debug.

We're seeing boot failure when using isolinux with the latest kernels,
but so far only on Dell machines. It loads the kernel and initrd, types
"Ready." and then just reboots. Adding "vga=ask" gives the mode prompt
and allows selecting a video mode, but it just reboots after that too.

