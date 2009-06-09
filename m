Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbZFIW3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbZFIW3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZFIW32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:29:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbZFIW31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:29:27 -0400
Date: Tue, 9 Jun 2009 15:28:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: jbarnes@virtuousgeek.org, penberg@cs.helsinki.fi,
       intel-gfx@lists.freedesktop.org, woodys@xandros.com,
       stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
       apw@canonical.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [Intel-gfx] Intel 915GM MCHBAR bug
Message-Id: <20090609152828.d82528f3.akpm@linux-foundation.org>
In-Reply-To: <20090609150757.4a2109a9@jbarnes-x200>
References: <4A242C81.6020906@cs.helsinki.fi>
	<4A298971.5080006@xandros.com>
	<4A2A0951.1020608@cs.helsinki.fi>
	<20090605232711.d8503262.akpm@linux-foundation.org>
	<4A2A0E8C.1010109@cs.helsinki.fi>
	<20090606212759.31970fae@jbarnes-x200>
	<20090609150757.4a2109a9@jbarnes-x200>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 15:07:57 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> > > Andrew Morton wrote:
> > > > These might end up being 2.6.30.1 material.
> > > 
> > > Yes, agreed completely. We probably want ACK from Jesse and Bjorn,
> > > though.
> > 
> > I'm ok with it being 2.6.30.1 stuff, but given the significance of the
> > change we were worried about putting it into 2.6.30 late in the cycle.
> > But as you say, it's a very important performance fix for many
> > machines...
> > 
> > Anyway, Eric may already have it merged.  Eric?
> > 
> 
> It's merged now into the drm-intel-next tree, and therefore queued for
> the merge window.

<hunts around for a while>

This? http://git.kernel.org/?p=linux/kernel/git/anholt/drm-intel.git;a=commitdiff;h=d765898970f35acef960581f678b9da9d5c779fa;hp=1b8e69662e1a086878bf930a6042daf7f8a076cc

It doesn't have cc:stable in the changelog, so there's a reasonable
chance that it will get lost.

The -stable guys troll the commit list looking for mainline commits
which mention stable@kernel.org in the changelog.

