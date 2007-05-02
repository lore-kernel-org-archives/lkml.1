Return-Path: <linux-kernel-owner+w=401wt.eu-S1766890AbXEBR4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766890AbXEBR4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766991AbXEBR4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:56:10 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51530 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766890AbXEBR4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:56:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rajib Majumder" <rajibm2005@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Scalability
References: <fdb8a7ad0705020556t5015f95fqbd2638dd4636db87@mail.gmail.com>
Date: Wed, 02 May 2007 11:55:58 -0600
In-Reply-To: <fdb8a7ad0705020556t5015f95fqbd2638dd4636db87@mail.gmail.com>
	(Rajib Majumder's message of "Wed, 2 May 2007 20:56:07 +0800")
Message-ID: <m1fy6fw1n5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rajib Majumder" <rajibm2005@gmail.com> writes:

> Hi,
>
> I am wondering if 2.4.x/2.6.x kernel is scalable enough to run on
> 8-CPU hardware. Do we have any scalability comparison data between
> 2.4/2.6 kernels and beyond 4-CPU?
>
> If yes, is the scalablity is near linear?

I haven't a clue what the data looks like but it is worth
noting that Linux runs on the SGI Altix and the large Unisys
machines, as well as large RISC machines.  So 128+ cpus seems
to work.

It depends on your application and what it stresses but scalability
isn't just a software issue.  It is also a hardware issue, and the
kernel can't scale linearly unless the hardware does as well.

Eric
