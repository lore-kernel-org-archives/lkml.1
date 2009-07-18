Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbZGRFeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbZGRFeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 01:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZGRFeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 01:34:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbZGRFeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 01:34:05 -0400
Date: Fri, 17 Jul 2009 22:33:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David Miller <davem@davemloft.net>, zbr@ioremap.net,
       linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/3] connector: make callback argument type explicit
Message-Id: <20090717223307.d86a5551.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0907172045j2cff6987xb7ea0aab438bef9d@mail.gmail.com>
References: <1247696049-15699-1-git-send-email-vapier@gentoo.org>
	<20090716101957.GA9586@ioremap.net>
	<20090717.101550.223298982.davem@davemloft.net>
	<8bd0f97a0907172045j2cff6987xb7ea0aab438bef9d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 23:45:35 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Fri, Jul 17, 2009 at 13:15, David Miller wrote:
> > From: Evgeniy Polyakov <zbr@ioremap.net>
> >>
> >> Your patches look good, thanks a lot.
> >> David, please apply to the appropriate tree.
> >
> > Applied to net-next-2.6, but I am being very generous.
> >
> > In the future please make sure netdev@vger.kernel.org receives all
> > networking patch postings so that they properly get tracked at:
> >
> > __ __ __ __http://patchwork.ozlabs.org/project/netdev/list/
> >
> > Otherwise they risk getting lost.
> 
> the fact that the connector code is maintained in the net tree is not
> mentioned anywhere that i can see.  it isnt in net/, it isnt in
> drivers/net/, and it isnt in MAINTAINERS.  that means anyone who
> wishes to submit patches has to basically guess where to send them.
> going by the default rules, that means the author (Evgeniy) and LKML.
> expecting people to magically divine net ownership with this driver is
> ridiculous.

y:/usr/src/git26> perl scripts/get_maintainer.pl -f drivers/connector/*.c
James Morris <jmorris@namei.org>                                         
Serge Hallyn <serue@us.ibm.com>
David Howells <dhowells@redhat.com>
Marc Dionne <marc.c.dionne@gmail.com>
Frederic Weisbecker <fweisbec@gmail.com>
Evgeniy Polyakov <zbr@ioremap.net>
David S. Miller <davem@davemloft.net>
linux-kernel@vger.kernel.org


Major fail!

A MAINTAINERS record should fix that up.
