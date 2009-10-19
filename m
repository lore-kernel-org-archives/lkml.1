Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZJTABB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZJTABB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbZJTABA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:01:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39956 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913AbZJTABA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:01:00 -0400
Message-Id: <1255996189.8924.1340920415@webmail.messagingengine.com>
X-Sasl-Enc: 2C/JxUDPUuDMaN/KbtFC0bNsFPtcXVpXKBIPdG8a7qcc 1255996189
From: myuboot@fastmail.fm
To: "David Daney" <ddaney@caviumnetworks.com>
Cc: linux-kernel@vger.kernel.org, "linux-mips" <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <4AD906D8.3020404@caviumnetworks.com>
References: <1255735395.30097.1340523469@webmail.messagingengine.com>
 <4AD906D8.3020404@caviumnetworks.com>
Subject: Re: 2.6.31 kernel for mips compile failure - war.h:12:17: error: war.h:
 No such file or directory
Date: Mon, 19 Oct 2009 18:49:49 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. This issue is fixed now. In 2.6.31 the directory
include/asm-mips  is moved as arch/mips/include/asm/. I need to change
my Makefile accordingly.

On Fri, 16 Oct 2009 16:50 -0700, "David Daney"
<ddaney@caviumnetworks.com> wrote:
> mips-linux questions will get more attention if you send them to 
> linux-mips@linux-mips.org.
> 
> 
> myuboot@fastmail.fm wrote:
> > I am trying to use buildroot 2009.08 to compile kernel 2.6.31 for mips,
> > but it fails to error -" war.h can't be found". I used the same
> > buildroot to build kernel version 2.6.29 with no problem. 
> > 
> > Please give me some suggestion on how to fix this issue. The file 
> > ./arch/mips/include/asm/war.h is there with no problem. Thanks a lot.
> > 
> [...]
> >   CC      arch/mips/kernel/asm-offsets.s
> > In file included from
> > /home/root123/sources/buildroot-2009.08-k/project_build_mips/f1/linux-2.6.31/arch/mips/include/asm/bitops.h:24,
> >                  from include/linux/bitops.h:17,
> >                  from include/linux/kernel.h:15,
> >                  from include/linux/sched.h:52,
> >                  from arch/mips/kernel/asm-offsets.c:13:
> 
> What does your .config look like?
> 
> Also try make V=1 so we can see the exact compiler command line that the 
> build process is generating.
> 
> David Daney
