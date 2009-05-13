Return-Path: <linux-kernel-owner+w=401wt.eu-S1760906AbZEMTuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760906AbZEMTuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZEMTtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:49:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:53409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbZEMTtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:49:55 -0400
Subject: Re: [RFC][PATCH -tip] x86: audit.c remove unnecessary global
 arraysn
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0905132136300.3561@localhost.localdomain>
References: <1242240694.3364.3.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905132136300.3561@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 01:19:18 +0530
Message-Id: <1242244159.3364.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-13 at 21:42 +0200, Thomas Gleixner wrote:
> On Thu, 14 May 2009, Jaswinder Singh Rajput wrote:
>  
> > ia32_dir_class[], ia32_write_class[], ia32_read_class[], ia32_chattr_class[]
> > and ia32_signal_class[] are used only by arch/x86/kernel/audit_64.c
> > which can be replace by local variables:
> > 
> > dir_class[], write_class[], read_class[], chattr_class[] and signal_class[]
> 
> Groan, it can be replaced by local variables, but it does not result
> in the same functionality.
> 
> These audit classes are arrays of syscall numbers, which are different
> for 32 and 64 bit. ia32/audit.c includes unistd_32.h not unistd.h for
> exactly this reason.
> 

Thanks, got it :-)

--
JSR

