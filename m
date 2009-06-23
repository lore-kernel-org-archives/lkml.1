Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbZFWPFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbZFWPFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760351AbZFWPE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:04:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52636 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760565AbZFWPE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:04:57 -0400
Date: Tue, 23 Jun 2009 18:04:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
	notifier race conditions
Message-ID: <20090623150415.GA21136@redhat.com>
References: <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com> <4A3FE445.4090204@gmail.com> <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com> <4A4029F7.6070502@gmail.com> <alpine.DEB.1.10.0906221808010.10952@makko.or.mcafeemobile.com> <4A402F55.8040501@gmail.com> <alpine.DEB.1.10.0906230728320.16382@makko.or.mcafeemobile.com> <4A40E89F.3060207@gmail.com> <alpine.DEB.1.10.0906230732250.16382@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906230732250.16382@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 07:35:00AM -0700, Davide Libenzi wrote:
> On Tue, 23 Jun 2009, Gregory Haskins wrote:
> 
> > Davide Libenzi wrote:
> > > On Mon, 22 Jun 2009, Gregory Haskins wrote:
> > >
> > >   
> > >> To be honest, I am not sure.  I would guess its not a *huge* deal,
> > >> though it was obviously enough of a concern to at least discuss it.  I
> > >> can definitely say that I think the other issues which are being fixed
> > >> are substantially more important.
> > >>     
> > >
> > > Ok then, will repost the revised patch later today.
> > >   
> > 
> > Ok sounds good.  I did have a chance to take a closer look at your
> > proposal for the key data, and I think it makes a lot of sense.  Do you
> > see it as a problem if we defer adding that?  Or should we try to add
> > that notion now?
> 
> That would need to go eventually via mainline, after some discussion. But 
> yes, I believe that using the "key" as simple bitmask is a little 
> restrictive.
> 
> 
> - Davide

I agree.

