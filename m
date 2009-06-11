Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZFKUei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZFKUei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 16:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZFKUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 16:34:31 -0400
Received: from outbound-mail-26.bluehost.com ([69.89.17.191]:42711 "HELO
	outbound-mail-26.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751232AbZFKUea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 16:34:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sfXtddpYxsd8eteJt1RQB2LJAW1234B6kzNnKcVVkQ5zF0oB37lQW0YrndspwFn63vxEfJliKV/hJeSKPpAyc3izpYjAe5YBR8qdsSWPimxpQO3Z2Jh24I+VpOxt/iSO;
Date: Thu, 11 Jun 2009 13:33:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Anholt <eric@anholt.net>, penberg@cs.helsinki.fi, elendil@planet.nl,
       linux-kernel@vger.kernel.org, apw@canonical.com,
       colin.king@canonical.com, tim.gardner@canonicalc.com,
       bjorn.helgaas@hp.com
Subject: Re: [PATCH 2/2] pnp: add PNP resource range checking function
Message-ID: <20090611133347.1e79b950@jbarnes-g45>
In-Reply-To: <20090609150944.6ffa8038.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0906060934500.11247@melkki.cs.Helsinki.FI>
	<200906060931.36168.elendil@planet.nl>
	<4A2A1AB6.9020808@cs.helsinki.fi>
	<1244508839.7564.0.camel@gaiman.anholt.net>
	<20090609150944.6ffa8038.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 15:09:44 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 08 Jun 2009 17:53:59 -0700
> Eric Anholt <eric@anholt.net> wrote:
> 
> > On Sat, 2009-06-06 at 10:28 +0300, Pekka Enberg wrote:
> > > Hi Frans,
> > > 
> > > Frans Pop wrote:
> > > >> Add a PNP resource range check function, indicating whether a
> > > >> resource has been assigned to any device.
> > > > 
> > > > Shouldn't this patch come *before* your patch 1/2?
> > > > You now seem to use this function in a commit where it has not
> > > > yet been defined, which could result in build errors during
> > > > bisections.
> > > 
> > > Yes, correct. Sorry about that!
> > > 
> > > 			Pekka
> > 
> > This is already in drm-intel-next
> > 
> 
> Neither patch is in linux-next.  So either a) drm-intel-next contains
> 2.6.31 material or b) your processes broke.

drm-intel-next gets into linux-next by way of drm-next.  Not sure if
Dave has pulled Eric's bits yet though.

> Either way, these patches fix a "serious performance regression".
> They should be merged into 2.6.30 or 2.6.30.x, shouldn't they?

I'm still a little nervous about this, but I won't block it.  Since the
commits don't have stable@kernel.org cc'd I guess Pekka will just have
to send a note to stable when they go upstream.

-- 
Jesse Barnes, Intel Open Source Technology Center
