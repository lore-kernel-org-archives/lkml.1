Return-Path: <linux-kernel-owner+w=401wt.eu-S1761289AbZDQPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761289AbZDQPZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZDQPZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:25:44 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46852 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756999AbZDQPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:25:43 -0400
Date: Fri, 17 Apr 2009 11:25:42 -0400
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SSE soft emulation for Linux?
Message-ID: <20090417152542.GG3797@csclub.uwaterloo.ca>
References: <alpine.LSU.2.00.0904171632550.3060@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0904171632550.3060@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 04:46:25PM +0200, Jan Engelhardt wrote:
> well as it happens, a user reported to me that some binary userspace 
> blobs shipped with popular game servers crashes with Illegal 
> Instruction. Upon review, the program tries to execute SSE code, which, 
> of course, is bound to fail on older CPUs (see below for /proc/cpuinfo).
> 
> So I was wondering if there is an SSE emulation kit (for x86_32) similar 
> to the FPU emu code for arch/x86/, to deal with such cases.

I think such emulation would be very slow, and completely defeat the
purpose of using SSE in the application in the first place.

I would think either nag the provider to fix the code to support both
with and without SSE, or don't run the code on anything that old.
I guess Pentium 3 and Athlon XP would be the lowest choices.

Nvidia started requiring SSE in their binary drivers, but have since
backed out that requirement, so it is possible to make people realize
their code has unreasonable requirements.

I do find it amusing that microsoft keeps telling people to use
Silverlight, yet it requires SSE so lots of Athlon's and some Pentium
2s running Windows XP are simply out of luck.  Flash of course has no
such pointless minimal requirements and works everywhere.

I certainly have a number of non SSE machines in active use, so I
think requiring SSE is a mistake.  Maybe in a nother 5 years it will
be reasonable, although by then requiring 64bit might be fair too which
always has SSE.

-- 
Len Sorensen
