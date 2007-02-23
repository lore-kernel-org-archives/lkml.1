Return-Path: <linux-kernel-owner+w=401wt.eu-S932640AbXBWPnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640AbXBWPnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXBWPnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:43:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbXBWPnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:43:12 -0500
Message-ID: <45DF0B42.2080208@redhat.com>
Date: Fri, 23 Feb 2007 10:41:54 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: Sergey Vlasov <vsu@altlinux.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mit-devel@lists.printk.net
Subject: Re: module-init-tools-3.3-pre10 available
References: <45DD0031.9010808@redhat.com>	<20070222170732.22c1320b.vsu@altlinux.ru>	<45DDAE24.6080905@redhat.com> <20070223120136.12ea11db@home.brethil>
In-Reply-To: <20070223120136.12ea11db@home.brethil>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Fernando N. Capitulino wrote:
> On Thu, 22 Feb 2007 09:52:20 -0500
> Jon Masters <jcm@redhat.com> wrote:
> 
> | Sergey Vlasov wrote:
> | 
> | > I see that you have merged some patches which change depmod.8.
> | > However, this file is generated from doc/depmod.sgml, which was not
> | > changed appropriately.
> | 
> | Ah. A valid point - Luiz, do you want to redo your patch or I can take a 
> | look at the SGML source myself.
> 
>  Urgh, I didn't know that, sorry.
> 
>  I can redo my patch, but shouldn't the manpages be removed from the
> repository then?

I think it's like the configure/Makefile.in situation. These files 
should technically not be in the repo either (and you removed them in 
your tree) but I re-added them because people have an expectation that:

./configure
make

will do something "out of the box". I just need to re-run 
autoconf/automake periodically to keep the files up to date. It's a 
pain, but I'll script that in due course alongside rebuilding the man 
pages - actually, this is probably just a convenient makefile target.

So if you want to redo the patch against those man pages, I'll 
regenerate them prior to pushing the next update. We'll leave it as it 
is until then because the update (IIRC) was just to re-order existing 
content so it's not like we have to push this with urgency.

Jon.
