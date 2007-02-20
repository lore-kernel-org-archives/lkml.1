Return-Path: <linux-kernel-owner+w=401wt.eu-S964921AbXBTOZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921AbXBTOZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964923AbXBTOZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:25:20 -0500
Received: from mail.screens.ru ([213.234.233.54]:57863 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964921AbXBTOZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:25:19 -0500
Date: Tue, 20 Feb 2007 17:25:12 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070220142512.GB155@tv-sign.ru>
References: <20070218214359.GA4226@tv-sign.ru> <20070219110021.GA2190@ff.dom.local> <20070219120353.GC91@tv-sign.ru> <20070219132703.GC2190@ff.dom.local> <20070219150445.GC75@tv-sign.ru> <20070220132538.GG981@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220132538.GG981@ff.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Jarek Poplawski wrote:
>
> On Mon, Feb 19, 2007 at 06:04:45PM +0300, Oleg Nesterov wrote:
> > On 02/19, Jarek Poplawski wrote:
> > >
> > > It looks like it's to be checked before kfree.
> > 
> > Here,
> > 	br_add_if:
> ...
> 
> I meant "it's to be checked",

Jarek, I was too quick and misread your message, sorry!

>                               if it's used by a program.
> The name: work_release seems to tell the work function
> could signal, when it doesn't need a structure no more.
> But br_if.c doesn't seem to use this infomation now,
> so there should be no difference after changing to
> "without _NAR". This change will limit some potential
> changes in the future, but if it's not used by anybody
> than the simpler api is a gain.

Agreed.

Oleg.

