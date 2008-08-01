Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYHANea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYHANea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYHANeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:34:15 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:48350 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbYHANeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:34:14 -0400
Date: Fri, 1 Aug 2008 16:33:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Or Gerlitz <ogerlitz@voltaire.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: error building linus tree (2.6.27-rc1)
Message-ID: <20080801133313.GB24735@cs181140183.pp.htv.fi>
References: <Pine.LNX.4.64.0807292357040.3348@zuben.voltaire.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807292357040.3348@zuben.voltaire.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 12:00:56AM +0300, Or Gerlitz wrote:
> I get into this
> 
>   CC	  arch/x86/kernel/irq_64.o
>   CC      arch/x86/kernel/time_64.o
>   CC      arch/x86/kernel/ioport.o
>   CC      arch/x86/kernel/ldt.o
> arch/x86/kernel/ldt.c: In function `alloc_ldt':
> arch/x86/kernel/ldt.c:67: error: invalid lvalue in unary `&'
> make[1]: *** [arch/x86/kernel/ldt.o] Error 1
> make: *** [arch/x86/kernel] Error 2
> 
> with the attached .config, for a clone of
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> is there anything I do wrong?

Please send the output of
  gcc --version
  as --version

> Or.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

