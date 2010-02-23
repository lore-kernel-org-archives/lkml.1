Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0BWUmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:42:44 -0500
Received: from ozlabs.org ([203.10.76.45]:33755 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab0BWUmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:42:42 -0500
From: Michael Neuling <mikey@neuling.org>
To: Greg KH <greg@kroah.com>
cc: Greg KH <gregkh@suse.de>, Serge Hallyn <serue@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Anton Blanchard <anton@samba.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Americo Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [29/93] fs/exec.c: restrict initial stack space expansion to rlimit
In-reply-to: <20100223153412.GB4275@kroah.com>
References: <20100219163238.671588178@kvm.kroah.org> <11054.1266734564@neuling.org> <20100223153412.GB4275@kroah.com>
Comments: In-reply-to Greg KH <greg@kroah.com>
   message dated "Tue, 23 Feb 2010 07:34:12 -0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 24 Feb 2010 07:42:41 +1100
Message-ID: <9355.1266957761@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20100223153412.GB4275@kroah.com> you wrote:
> On Sun, Feb 21, 2010 at 05:42:44PM +1100, Michael Neuling wrote:
> > In message <20100219163238.671588178@kvm.kroah.org> you wrote:
> > > 2.6.32-stable review patch.  If anyone has any objections, please let us 
know
> > .
> > > 
> > > ------------------
> > > 
> > > From: Michael Neuling <mikey@neuling.org>
> > > 
> > > commit 803bf5ec259941936262d10ecc84511b76a20921 upstream.
> > > 
> > > When reserving stack space for a new process, make sure we're not
> > > attempting to expand the stack by more than rlimit allows.
> > 
> > This breaks UML, so you also need to take this also:
> > 
> >   http://patchwork.kernel.org/patch/79365/
> > 
> > It's in akpm's tree only so far.
> 
> As I can't take patches that are not in Linus's tree, can you let
> stable@kernel.org know the git commit id of the patch when it goes into
> Linus's tree, and then I will apply it to the next .32-stable release?

No problems.  Actually, Linus took it over night.  SHA1 is
a17e18790a8c47113a73139d54a375dc9ccd8f08 "fs/exec.c: fix initial stack
reservation"

I'll send a note to stable now.

Mikey
