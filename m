Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbZK3JZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbZK3JZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZK3JZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:25:40 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:44067 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbZK3JZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:25:37 -0500
Date: Mon, 30 Nov 2009 10:24:44 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the pcmcia tree with the pxa tree
Message-ID: <20091130102444.4ebc0a45@life-in-the-fast-lane>
In-Reply-To: <f17812d70911300016q1e729569k8c72deb704e3a658@mail.gmail.com>
References: <20091130131627.8ccc6033.sfr@canb.auug.org.au>
	<f17812d70911291917y2aeebbberbf31775491f0df4f@mail.gmail.com>
	<20091130091007.7a5fd554@hina.wild-wind.fr.eu.org>
	<f17812d70911300016q1e729569k8c72deb704e3a658@mail.gmail.com>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.210.249.81
X-SA-Exim-Rcpt-To: eric.y.miao@gmail.com, sfr@canb.auug.org.au, linux@dominikbrodowski.net, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 16:16:38 +0800
Eric Miao <eric.y.miao@gmail.com> wrote:

> On Mon, Nov 30, 2009 at 4:10 PM, Marc Zyngier <maz@misterjones.org>
> wrote:
> > On Mon, 30 Nov 2009 11:17:08 +0800
> > Eric Miao <eric.y.miao@gmail.com> wrote:
> >
> > Hi Eric,
> >
> >> Could you take a look into this, I wonder you may need to rebase
> >> against Russell's PCMCIA generalization stuffs. Let me know if you
> >> want me to drop this patch.
> >
> > Patch looks good. I'm more worried about creating dependencies
> > between trees:
> >
> > - Stephen fix depends on Russell's changes, which are in Dominik's
> > tree,
> > - My patch depends on Zeus support, which is in your tree,
> > - Rebasing Zeus PCMCIA support against Dominik's tree is just
> > another dependency between the two trees.
> >
> > Should we drop my PCMCIA changes until both Russell's changes and
> > main Zeus support are merged?
> >
> 
> I'd propose to postpone your patches until dependency is resolved,
> will send a second git pull til then. Sounds OK to you?

Sounds good. I'll post rebased patches as soon as PCMCIA hits Linus'
tree.

Thanks,

	M.
-- 
Fast. Cheap. Reliable. Pick two.
