Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYFKMkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYFKMkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYFKMkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:40:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44217 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYFKMkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:40:15 -0400
To: peter.oberparleiter@de.ibm.com
CC: sam@ravnborg.org, oberparleiter@googlemail.com, miklos@szeredi.hu,
       jdike@addtoit.com, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
In-reply-to: <484FC29E.6040507@de.ibm.com> (message from Peter Oberparleiter
	on Wed, 11 Jun 2008 14:18:38 +0200)
Subject: Re: 2.6.26-rc5-mm1: uml link error
References: <OF61F32674.CE1F9CB0-ONC1257464.004D17DC-C1257464.004DB50E@de.ibm.com> <484E8DD2.5050603@de.ibm.com> <20080610172150.GA4728@uranus.ravnborg.org> <484FC29E.6040507@de.ibm.com>
Message-Id: <E1K6Pb2-000423-3t@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jun 2008 14:38:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Agreed. In that case the SORT(CONSTRUCTORS) statement in
> arch/um/kernel/dyn.lds.S needs to be changed as well though (see my
> previous patch in this thread) or we get the linker error detailed
> in the original post.
> 
> > And we could get away with some flag or something where we 
> > call the constructors.
> 
> The decision whether constructors should be called or not is made at
> configuratiom time - I don't see a variable fitting into this scheme.
> The only alternative I could imagine would be to introduce a hidden
> config symbol CONFIG_CTORS which would be auto-selected by all archs
> except for uml.
> 
> > And a comment explaning why UML is different is also missing.
> 
> Done. Here comes the modifed patch: applies on top of
> kernel-call-constructors.patch, together with the remove-sort-
> construct patch:

With both patches applied builds and boots fine.  Thanks.

> --
> kernel: disable constructor calling for uml
> 
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Disable calling of constructor functions for uml as they are already
> called by the host run-time environment.
> 
> Found-by: Miklos Szeredi <miklos@szeredi.hu>

I believe the usual form is "Reported-by:".

Thanks,
Miklos
