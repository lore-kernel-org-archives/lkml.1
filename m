Return-Path: <linux-kernel-owner+w=401wt.eu-S1763948AbXJEWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763948AbXJEWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 18:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbXJEWZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 18:25:18 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49605 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761844AbXJEWZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 18:25:17 -0400
Date: Fri, 5 Oct 2007 15:24:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: schwab@suse.de, rpjday@mindspring.com, bbpetkov@yahoo.de,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, satyam@infradead.org,
       amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
Message-Id: <20071005152450.a7652b75.akpm@linux-foundation.org>
In-Reply-To: <4706AC8D.1030100@goop.org>
References: <20070918194647.GA23800@gollum.tnic>
	<20071005124705.6584e2f9.akpm@linux-foundation.org>
	<4706A20A.5060603@goop.org>
	<20071005140050.655b7727.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0710051701530.12079@localhost.localdomain>
	<jeve9lmf06.fsf@sykes.suse.de>
	<4706AC8D.1030100@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2007 14:28:45 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andreas Schwab wrote:
> > #define DMA_BIT_MASK(n)         ((u64)-1 >> (64 - (n)))
> >   
> 
> Yeah, that's cleaner.
> 

Well yes, but DMA_BIT_MASK(0) invokes undefined behaviour, generates a
compiler warning and evaluates to 0xffffffffffffffff (with my setup).

That won't be a problem in practice, but it is strictly wrong and doesn't set
a good exmaple for the children ;)

