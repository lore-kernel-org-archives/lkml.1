Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbYFMWRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbYFMWRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 18:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYFMWR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 18:17:27 -0400
Received: from gw.goop.org ([64.81.55.164]:51161 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbYFMWR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 18:17:26 -0400
Message-ID: <4852F1C8.7060904@goop.org>
Date: Fri, 13 Jun 2008 23:16:40 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: Tree for June 13 (XEN)
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080613101316.1c228fe7.randy.dunlap@oracle.com>
In-Reply-To: <20080613101316.1c228fe7.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> next-20080613 on x86_32 has lots of xen build errors like this:
>
> linux-next-20080613/arch/x86/xen/mmu.c: In function 'drop_mm_ref':
> linux-next-20080613/arch/x86/xen/mmu.c:759: error: implicit declaration of function 'xen_smp_call_function_mask'
> make[2]: *** [arch/x86/xen/mmu.o] Error 1
>
>   

Ooh, first time I've seen that.  Sounds like Jens' patches are missing 
the appropriate update there (though it's certainly had it in the past).

    J

