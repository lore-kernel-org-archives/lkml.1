Return-Path: <linux-kernel-owner+w=401wt.eu-S934706AbXHHOOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706AbXHHOOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbXHHOON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:14:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:41449 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXHHOOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:14:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Subject: Re: [PATCH 23/25] [PATCH] paravirt hooks for arch initialization
Date: Wed, 8 Aug 2007 16:13:26 +0200
User-Agent: KMail/1.9.6
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <200708081144.04119.ak@suse.de> <5d6222a80708080708h43b1521cp734bedd27f94723e@mail.gmail.com>
In-Reply-To: <5d6222a80708080708h43b1521cp734bedd27f94723e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081613.26613.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007 16:08:25 Glauber de Oliveira Costa wrote:
> On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> >
> > > -static void discover_ebda(void)
> > > +void native_ebda_info(unsigned *addr, unsigned *size)
> >
> > I guess it would be better to use the resources frame work here.
> > Before checking EBDA check if it is already reserved. Then lguest/Xen
> > can reserve these areas and stop using it.
> Let's make sure I understand: So you suggest skipping discover
> altogether in case it is already reserved?

Yes


> I don't know exactly what other kinds of hooks we could put there.
> lguest surely didn't need any. Are you okay with just turning it into
> void by now ?

Yes.

-Andi
