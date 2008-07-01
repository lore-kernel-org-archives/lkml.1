Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYGAIEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYGAIEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 04:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYGAIEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 04:04:25 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59727 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbYGAIEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 04:04:22 -0400
Message-ID: <4869E4FF.8030202@linux.vnet.ibm.com>
Date: Tue, 01 Jul 2008 13:34:15 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 30 - powerpc - build
 failure at arch_add_memory()
References: <20080701001656.e156585c.sfr@canb.auug.org.au> <486924FE.4090801@linux.vnet.ibm.com> <20080701013438.GT20457@bakeyournoodle.com>
In-Reply-To: <20080701013438.GT20457@bakeyournoodle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Breeds wrote:
> On Mon, Jun 30, 2008 at 11:55:02PM +0530, Kamalesh Babulal wrote:
>> Hi Stephen,
>>
>> next-20080630 kernel build fails on powerpc, with randconfig
>>
>>   CC      arch/powerpc/mm/mem.o
>> arch/powerpc/mm/mem.c: In function ‘arch_add_memory’:
>> arch/powerpc/mm/mem.c:130: error: implicit declaration of function ‘create_section_mapping’
>> make[1]: *** [arch/powerpc/mm/mem.o] Error 1
>> make: *** [arch/powerpc/mm] Error 2
> 
> This problem exists in in 2.6.26-rc8, so it's not specifially linux-next
> realted.  The patch at:
> http://patchwork.ozlabs.org/linuxppc/patch?id=19347
> should fix it but is un-ACK'd ;P
Hi Tony,

Thanks, the patch fixes the build failure on the machine.

> 
> Yours Tony
> 
>   linux.conf.au    http://www.marchsouth.org/
>   Jan 19 - 24 2009 The Australian Linux Technical Conference!
> 


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
