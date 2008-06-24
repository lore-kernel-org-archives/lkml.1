Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYFXUBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYFXUBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 16:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYFXUBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 16:01:31 -0400
Received: from mail.renesas.com ([202.234.163.13]:52934 "EHLO
	mail04.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbYFXUB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 16:01:29 -0400
X-AuditID: ac140387-00000004000005fd-75-4861529357e3
Date: Wed, 25 Jun 2008 05:01:08 +0900
From: Paul Mundt <paul.mundt@renesas.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] maple: tidy  maple_driver code by removing redundant
	connect/disconnect
Message-ID: <20080624200108.GC11705@renesas.com>
References: <1213559289.22707.15.camel@localhost.localdomain> <20080624040128.GB22526@linux-sh.org> <5703.85.118.17.158.1214305147.squirrel@newgolddream.dyndns.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5703.85.118.17.158.1214305147.squirrel@newgolddream.dyndns.info>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 11:59:07AM +0100, Adrian McMenamin wrote:
> On Tue, June 24, 2008 5:01 am, Paul Mundt wrote:
> > On Sun, Jun 15, 2008 at 08:48:09PM +0100, Adrian McMenamin wrote:
> >> The connect and disconnect functions are unnecessary - everything they
> >> do can be
> >> accomplished in the initial probe - so remove them.
> >>
> >> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> >
> > Applied, thanks.
> >
> Paul,
> 
> Just to note that this (http://lkml.org/lkml/2008/6/15/122) will break the
> keyboard driver unless this (http://lkml.org/lkml/2008/6/15/121) is also
> applied.
> 
> I haven't heard back from Dmitry on the keyboard patch yet.
> 
Yes, I'm aware of that. This should fix itself in linux-next once it is
merged in the input tree, and I don't intend on pushing my changes until
that's in place, so we don't break bisection.
