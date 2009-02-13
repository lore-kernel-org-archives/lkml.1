Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZBMRFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZBMRFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 12:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbZBMRFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 12:05:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:42564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZBMRFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 12:05:37 -0500
Subject: Re: [PATCH 4/7] x86: memtest: adapt log messages
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20090213165302.GA24299@elte.hu>
References: <20090213144600.GA6298@alberich.amd.com>
	 <20090213145517.GD13000@alberich.amd.com>  <20090213165302.GA24299@elte.hu>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 22:34:56 +0530
Message-Id: <1234544696.26783.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 17:53 +0100, Ingo Molnar wrote:
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > +#ifdef CONFIG_X86_64
> > +			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
> > +			       t_start, t_start + t_size, cpu_to_be64(pattern));
> > +#else
> > +			printk(KERN_CONT "\n  %010llx - %010llx pattern %08x",
> > +			       t_start, t_start + t_size, cpu_to_be32(pattern));
> > +#endif
> 
> hm, is there really no cleaner way to do this?
> 

Can we use this:

+			printk(KERN_CONT "\n  %010llx - %010llx pattern %016llx",
+			       t_start, t_start + t_size, cpu_to_be64(pattern));

--
JSR



