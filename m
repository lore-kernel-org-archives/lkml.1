Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZCVQGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZCVQGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 12:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZCVQGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 12:06:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZCVQGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 12:06:40 -0400
Date: Sun, 22 Mar 2009 12:06:29 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Phonet:fix build problem
Message-ID: <20090322160629.GA23227@bombadil.infradead.org>
References: <20090320115838.GA26371@orion> <20090321.165950.248659848.davem@davemloft.net> <a4423d670903211719m76baeab0k51f054058d6f5134@mail.gmail.com> <1237694320.25297.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237694320.25297.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 03:58:40AM +0000, James Bottomley wrote:
> > > I think that platform's atomic_add() implementation should
> > > be fixed instead.
> > 
> > It is parisc, CC added.
> 
> Looks like a macro argument screw up in atomic.h
> 
> This should fix it (uncompiled, of course).
> 

Looks correct to me. Applied. Thanks everyone.
