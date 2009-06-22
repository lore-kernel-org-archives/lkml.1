Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZFVSsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZFVSsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZFVSsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:48:03 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42684 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZFVSsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:48:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 22 Jun 2009 11:41:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [KVM PATCH v3 3/3] KVM: Fix races in irqfd using new eventfd_kref_get
 interface
In-Reply-To: <20090622183222.GF15228@redhat.com>
Message-ID: <alpine.DEB.1.10.0906221140570.10952@makko.or.mcafeemobile.com>
References: <20090622155504.22967.50532.stgit@dev.haskins.net> <20090622160556.22967.76273.stgit@dev.haskins.net> <20090622165708.GB15228@redhat.com> <4A3FBFF1.8050504@gmail.com> <20090622174506.GD15228@redhat.com> <alpine.DEB.1.10.0906221105500.10952@makko.or.mcafeemobile.com>
 <20090622183222.GF15228@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Michael S. Tsirkin wrote:

> On Mon, Jun 22, 2009 at 11:11:12AM -0700, Davide Libenzi wrote:
> > On Mon, 22 Jun 2009, Michael S. Tsirkin wrote:
> > 
> > > Not really, it's impossible to document all races one have thought
> > > about and avoided.
> > 
> > Well, when some new code has non-trivial locking/racing logics, you better 
> > document it as clearly as possible, akpm announced time ago.
> 
> Absolutely. But IMO documentation in the form of "fields A B C are
> protected by lock X" in a single place near field declaration is better
> than "we take lock X here to protect against race with user thread using
> fields A B C" sprinkled all over the code.

Exactly what akpm suggested. A fat comment on top of the C file describing 
locking logic and pitfalls.


- Davide


