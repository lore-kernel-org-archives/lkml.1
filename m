Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbZFVTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbZFVTgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZFVTgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:36:02 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45661 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbZFVTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:36:00 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 12:29:48 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <4A3FDAF1.6010700@novell.com>
Message-ID: <alpine.DEB.1.10.0906221223240.10952@makko.or.mcafeemobile.com>
References: <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com>
 <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com> <20090622184139.GG15228@redhat.com> <alpine.DEB.1.10.0906221146210.10952@makko.or.mcafeemobile.com>
 <20090622190537.GI15228@redhat.com> <4A3FDAF1.6010700@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Gregory Haskins wrote:

> Michael S. Tsirkin wrote:
> > On Mon, Jun 22, 2009 at 11:51:42AM -0700, Davide Libenzi wrote:
> >   
> >> A file* based kernel-to-kernel interface is rather wrong IMO.
> >>     
> >
> > But eventfd_ctx should work fine.
> >   
> 
> Yeah, and I guess we can always just say that qemu can't close the fd or
> something.  Seems hacky, but it might work if Davide insists we need his
> change.

Continuing here, since there's no reason of having many subthreads talking 
about the same thing.
Can you make a detailed example of what you're trying to achieve (no Hint 
Mode, please)?
As it sounds to me, that you need a consumer/producer reference counting, 
to cover your scenario correctly.



- Davide


