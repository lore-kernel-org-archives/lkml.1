Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXBSNXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXBSNXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbXBSNXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:23:41 -0500
Received: from mx2.go2.pl ([193.17.41.42]:41441 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932222AbXBSNXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:23:40 -0500
Date: Mon, 19 Feb 2007 14:27:03 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S\. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] net/bridge/br_if.c: don't use _WORK_NAR
Message-ID: <20070219132703.GC2190@ff.dom.local>
References: <20070218214359.GA4226@tv-sign.ru> <20070219110021.GA2190@ff.dom.local> <20070219120353.GC91@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219120353.GC91@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 03:03:53PM +0300, Oleg Nesterov wrote:
> On 02/19, Jarek Poplawski wrote:
...
> kfree() doesn't check WORK_STRUCT_PENDING, it makes no
> difference if it is set or not when work->func() runs.

It looks like it's to be checked before kfree.

> > So, even if this functionality isn't used now, I can't
> > see what changing this could buy.
> 
> We are going to kill _NAR stuff.

If you're sure nobody uses this in any way then it
seems the right decision.

Jarek P.
