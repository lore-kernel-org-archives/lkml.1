Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZEHTlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZEHTlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 15:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZEHTln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 15:41:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50024 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbZEHTlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:41:42 -0400
Message-ID: <4A048AF4.1080205@garzik.org>
Date: Fri, 08 May 2009 15:41:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Grozdan <neutrino8@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux and LLVM
References: <c5bd819b0905081228m4ee6472bhc3968b178f038b9c@mail.gmail.com>
In-Reply-To: <c5bd819b0905081228m4ee6472bhc3968b178f038b9c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grozdan wrote:
> Hi,
> 
> First, I'd like to say that I'm not interested in any holy wars,
> trolling, ego-boosters, or whatever, and basically want to ask a
> simple question and get the views of the Linux developers on it, at
> least from those who are interested in answering it or have time to do
> so as I know that most kernel devs are very busy :)
> 
> Recently, FreeBSD has reported that it's slowly switching from GCC to
> LLVM/CLANG for compilers. What are the thoughts of the Linux kernel
> devs about this and do they things that it's a good idea to go in the
> same direction as FreeBSD (switching over to LLVM)?

It is highly unlikely we will switch compilers away from gcc -- we have 
enough problems just supporting multiple gcc versions.

That said, you could join the effort to get LLVM to compile under the 
kernel.  Here is a meta-bug for that: 
http://llvm.org/bugs/show_bug.cgi?id=4068

It is a moot question until LLVM can actually build a bootable kernel :)

Regards,

	Jeff



