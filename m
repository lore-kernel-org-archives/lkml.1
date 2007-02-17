Return-Path: <linux-kernel-owner+w=401wt.eu-S965135AbXBQKUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbXBQKUk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965136AbXBQKUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:20:39 -0500
Received: from www.osadl.org ([213.239.205.134]:39230 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965135AbXBQKUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:20:39 -0500
Subject: Re: 2.6.20-git: undefined reference to `smp_call_function_single'
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
In-Reply-To: <200702162108.01206.lenb@kernel.org>
References: <200702162108.01206.lenb@kernel.org>
Content-Type: text/plain
Date: Sat, 17 Feb 2007 11:25:24 +0100
Message-Id: <1171707924.30834.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 21:08 -0500, Len Brown wrote:
> Yes, an obscure .config, but it used to build before today:
>
> kernel/built-in.o: In function `tick_broadcast_on_off':
> (.text+0x1b6f0): undefined reference to `smp_call_function_single'

Yup, this obscure machine is missing smp_call_function_single().

James ?

	tglx


