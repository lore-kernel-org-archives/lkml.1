Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYBQUQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYBQUQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYBQUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:16:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:19014 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYBQUQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:16:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Hmx97rzYcDhNAi8fZqdVBFUyFdMTD5p/FU4tpWzC0yiDcymqwrAypdi5ltA+96CS5jSk59hKFHEqECS3vBqIAYnO+4vFvnHB/I/m5TwfRT+SXRmyqAunwE6TcqrtconUvEbSdQa0gpxn+BgWvMwc6beC6S0nB2qUBUNvJHrdQAc=
Date: Sun, 17 Feb 2008 23:15:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, ak@suse.de, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric
	constant
Message-ID: <20080217201554.GG31968@cvg>
References: <20080217151716.274134094@gmail.com> <20080217151925.402628615@gmail.com> <20080217185936.GB14588@uranus.ravnborg.org> <20080217190801.GC31968@cvg> <47B88FAA.9080603@zytor.com> <20080217200654.GF31968@cvg> <47B89501.5090108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B89501.5090108@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Sun, Feb 17, 2008 at 12:11:45PM -0800]
> Cyrill Gorcunov wrote:
>> Thanks Peter for comments. Peter could you clarify for me a bit
>> more on the string:
>> x86/kernel/head_32.S:339
>> 	/* Set up the stack pointer */
>> 	lss stack_start,%esp
>> but stack_start is defined as head_32.S:647
>> .data
>> ENTRY(stack_start)
>> 	.long init_thread_union+THREAD_SIZE
>> so stack_start *must* be aligned with THREAD_SIZE in vmlinux.lds
>> at compiling time. There is no PDA at this booting time. Am I wrong?
>> If you're too busy - just reply me like "Read the code" ;)
>
> That doesn't follow.
>
> You're saying that it *must* be aligned, I don't think that's true anymore; 
> I think nowadays it's more accurate to say that it *is* aligned, but I 
> don't think that's fundamental.
>
> 	-hpa
>

Thanks a lot, Peter.

		- Cyrill -
