Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbZFIWK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbZFIWK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 18:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZFIWKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 18:10:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbZFIWKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 18:10:17 -0400
Date: Tue, 9 Jun 2009 15:09:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Anholt <eric@anholt.net>
Cc: penberg@cs.helsinki.fi, elendil@planet.nl, linux-kernel@vger.kernel.org,
       apw@canonical.com, colin.king@canonical.com, tim.gardner@canonicalc.com,
       bjorn.helgaas@hp.com
Subject: Re: [PATCH 2/2] pnp: add PNP resource range checking function
Message-Id: <20090609150944.6ffa8038.akpm@linux-foundation.org>
In-Reply-To: <1244508839.7564.0.camel@gaiman.anholt.net>
References: <Pine.LNX.4.64.0906060934500.11247@melkki.cs.Helsinki.FI>
	<200906060931.36168.elendil@planet.nl>
	<4A2A1AB6.9020808@cs.helsinki.fi>
	<1244508839.7564.0.camel@gaiman.anholt.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Jun 2009 17:53:59 -0700
Eric Anholt <eric@anholt.net> wrote:

> On Sat, 2009-06-06 at 10:28 +0300, Pekka Enberg wrote:
> > Hi Frans,
> > 
> > Frans Pop wrote:
> > >> Add a PNP resource range check function, indicating whether a resource
> > >> has been assigned to any device.
> > > 
> > > Shouldn't this patch come *before* your patch 1/2?
> > > You now seem to use this function in a commit where it has not yet been 
> > > defined, which could result in build errors during bisections.
> > 
> > Yes, correct. Sorry about that!
> > 
> > 			Pekka
> 
> This is already in drm-intel-next
> 

Neither patch is in linux-next.  So either a) drm-intel-next contains
2.6.31 material or b) your processes broke.

Either way, these patches fix a "serious performance regression".  They
should be merged into 2.6.30 or 2.6.30.x, shouldn't they?

