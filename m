Return-Path: <linux-kernel-owner+w=401wt.eu-S1758398AbZFWOlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398AbZFWOlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbZFWOlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:41:12 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51262 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbZFWOlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:41:11 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 07:35:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Gregory Haskins <ghaskins@novell.com>,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A40E89F.3060207@gmail.com>
Message-ID: <alpine.DEB.1.10.0906230732250.16382@makko.or.mcafeemobile.com>
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com>
 <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com>
 <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com> <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com> <4A3FE445.4090204@gmail.com> <alpine.DEB.1.10.0906221418510.10952@makko.or.mcafeemobile.com> <4A4029F7.6070502@gmail.com>
 <alpine.DEB.1.10.0906221808010.10952@makko.or.mcafeemobile.com> <4A402F55.8040501@gmail.com> <alpine.DEB.1.10.0906230728320.16382@makko.or.mcafeemobile.com> <4A40E89F.3060207@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Mon, 22 Jun 2009, Gregory Haskins wrote:
> >
> >   
> >> To be honest, I am not sure.  I would guess its not a *huge* deal,
> >> though it was obviously enough of a concern to at least discuss it.  I
> >> can definitely say that I think the other issues which are being fixed
> >> are substantially more important.
> >>     
> >
> > Ok then, will repost the revised patch later today.
> >   
> 
> Ok sounds good.  I did have a chance to take a closer look at your
> proposal for the key data, and I think it makes a lot of sense.  Do you
> see it as a problem if we defer adding that?  Or should we try to add
> that notion now?

That would need to go eventually via mainline, after some discussion. But 
yes, I believe that using the "key" as simple bitmask is a little 
restrictive.


- Davide


