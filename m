Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbXHAQpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbXHAQpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXHAQpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:45:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41260 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbXHAQpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:45:42 -0400
Date: Wed, 1 Aug 2007 09:44:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rishikesh K Rajak <risrajak@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Olof Johansson <olof@lixom.net>
Subject: Re: build error on powerpc for 2.6.23-rc1-mm2
Message-Id: <20070801094442.b710279b.akpm@linux-foundation.org>
In-Reply-To: <OFFC0F3DEC.2DEDE1A8-ON6525732A.002DB5E7-6525732A.002DEF2C@in.ibm.com>
References: <OFFC0F3DEC.2DEDE1A8-ON6525732A.002DB5E7-6525732A.002DEF2C@in.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 13:52:05 +0530 Rishikesh K Rajak <risrajak@in.ibm.com> wrote:

> 
> Hi Andrew,
> 
> I am getting following error on powerpc almost for allyesconfig,
> allmodconfig.
> 
> Error produced:
> 
> PowerPC: allmodconfig,allyesconfig
> 
>   CC      arch/powerpc/mm/tlb_64.o
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:
>  Assembler messages:
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:27:
>  Error: Unrecognized opcode: `mtocrf'
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:138:
>  Error: Unrecognized opcode: `mtocrf'
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/copyuser_64.S:153:
>  Error: Unrecognized opcode: `mtocrf'
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:
>  Assembler messages:
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:15:
>  Error: Unrecognized opcode: `mtocrf'
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:131:
>  Error: Unrecognized opcode: `mtocrf'
> /home/risrajak/TEST2/TEST/linux/CurrentTest/23-rc1-mm2-testing/linux-2.6.23-rc1/arch/powerpc/lib/memcpy_64.S:146:
>  Error: Unrecognized opcode: `mtocrf'
> make[2]: *** [arch/powerpc/lib/memcpy_64.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
>   CC      arch/powerpc/sysdev/mpic_u3msi.o
> make[2]: *** [arch/powerpc/lib/copyuser_64.o] Error 1
> make[1]: *** [arch/powerpc/lib] Error 2
> 

Presumably, disabling CONFIG_POWER4_ONLY would fix that.

It could be that your toolchain is insufficiently recent.  Which
version of binutils are you using?
