Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYJ2IBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYJ2IBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYJ2IBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:01:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:46145 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYJ2IBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:01:40 -0400
Subject: Re: How do I printk <type> correctly?
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       ericvh@gmail.com, mfasheh@suse.com
In-Reply-To: <20081028161136.c652b9fd.randy.dunlap@oracle.com>
References: <20081023114133.GA30187@x200.localdomain>
	 <20081028161136.c652b9fd.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Oct 2008 10:00:04 +0200
Message-Id: <1225267204.4350.10.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Oct 2008 08:01:23.0457 (UTC) FILETIME=[89190710:01C9399C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 16:11 -0700, Randy Dunlap wrote:
> On Thu, 23 Oct 2008 15:41:33 +0400 Alexey Dobriyan wrote:
> 
> > If variable is of Type	use	printk format specifier.
> > ---------------------------------------------------------
> > 		int			%d or %x
> > 		unsigned int		%u or %x
> > 		long			%ld ot %lx
> > 		unsigned long		%lu or %lx
> > 		long long		%lld or %llx
> > 		unsigned long long	%llu or %llx
> > 		size_t			%zu or %zx
> > 		ssize_t			%zd or %zx
> > 
> > Raw pointer value SHOULD be printed with %p.
> > 
> > u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> > 
> > 	printk("%llu", (unsigned long long)u64_var);
> > 
> > s64 SHOULD be printed with %lld/%llx, (long long):
> > 
> > 	printk("%lld", (long long)s64_var);
> > 
> > If type is dependent on config option (sector_t), use format specifier
> > of biggest type and explicitly cast to it.
> > 
> > Reminder: sizeof() result is of type size_t.

Do we have this somewhere in Documentation? Would be nice to have it.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

