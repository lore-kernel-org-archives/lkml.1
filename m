Return-Path: <linux-kernel-owner+w=401wt.eu-S1764083AbXJEWdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764083AbXJEWdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 18:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXJEWc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 18:32:56 -0400
Received: from gw.goop.org ([64.81.55.164]:56937 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbXJEWcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 18:32:55 -0400
Message-ID: <4706BB8D.9070408@goop.org>
Date: Fri, 05 Oct 2007 15:32:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: schwab@suse.de, rpjday@mindspring.com, bbpetkov@yahoo.de,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, satyam@infradead.org,
       amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
References: <20070918194647.GA23800@gollum.tnic>	<20071005124705.6584e2f9.akpm@linux-foundation.org>	<4706A20A.5060603@goop.org>	<20071005140050.655b7727.akpm@linux-foundation.org>	<Pine.LNX.4.64.0710051701530.12079@localhost.localdomain>	<jeve9lmf06.fsf@sykes.suse.de>	<4706AC8D.1030100@goop.org> <20071005152450.a7652b75.akpm@linux-foundation.org>
In-Reply-To: <20071005152450.a7652b75.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well yes, but DMA_BIT_MASK(0) invokes undefined behaviour, generates a
> compiler warning and evaluates to 0xffffffffffffffff (with my setup).
>
> That won't be a problem in practice, but it is strictly wrong and doesn't set
> a good exmaple for the children ;)
>   

It's interesting that it doesn't seem to be possible to define this
without invoking some undefined behaviour.  But a device that supports 0
bits of DMA address probably isn't terribly concerned about this - it's
certainly better than making 64 bit masks warty.

    J
