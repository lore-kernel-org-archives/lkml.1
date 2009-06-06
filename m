Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZFFKUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZFFKUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 06:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZFFKUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 06:20:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:36939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZFFKUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 06:20:35 -0400
Subject: Re: [PATCH -tip] x86: cpu_debug.c prepare report if files are
 inappropriate or CPU is not supported
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1244224637.8212.6.camel@ht.satnam>
References: <1239725240.2966.4.camel@ht.satnam>
	 <20090414165052.GA2089@elte.hu> <1239728481.2966.21.camel@ht.satnam>
	 <20090414184222.GC11214@elte.hu>
	 <20090414200247.1d0a8667@lxorguk.ukuu.org.uk>
	 <20090414191622.GA797@elte.hu>
	 <1239773665.15436.9.camel@localhost.localdomain>
	 <20090415101700.GE6669@elte.hu>  <1244224637.8212.6.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 15:51:32 +0530
Message-Id: <1244283692.2475.50.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 23:27 +0530, Jaswinder Singh Rajput wrote:
> Hello Ingo,
> 
> On Wed, 2009-04-15 at 12:17 +0200, Ingo Molnar wrote:
> 
> > The main beef i had with your code is that it copies CPU enumeration 
> > over into some local variables (cpu_modelflag, cpu_model) with 
> > redundant encodings and decodings which dont fully work.
> > 
> > Is there anything that your encoding/decoding does that cannot be 
> > done via the standard methods?
> > 
> 
> I removed cpu model info. May be this will create some issues on ancient
> machine as now it depends on rdmsr_safe_on_cpu() and I hope it will be
> safe ;-)
> Can you please check this patch on ancient and latest machines.
> 
> 
> [PATCH] x86: cpu_debug remove model information to reduce encoding-decoding
> 
> Remove model information, encoding/decoding and reduce bookkeeping.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---

If you have any objections please let me know otherwise I will start
sending patches on top of this patch.

Thanks,
--
JSR


