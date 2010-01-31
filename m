Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276Ab0AaUio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab0AaUio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306Ab0AaUio
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:38:44 -0500
Received: from mail.perches.com ([173.55.12.10]:1681 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab0AaUin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:38:43 -0500
Subject: Re: [PATCH 09/10] mm/slab.c: Fix continuation line formats
From: Joe Perches <joe@perches.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm@kvack.org
In-Reply-To: <201001312132.19798.elendil@planet.nl>
References: <cover.1264967493.git.joe@perches.com>
	 <cover.1264967493.git.joe@perches.com>
	 <9d64ab1e1d69c750d53a398e09fe5da2437668c5.1264967500.git.joe@perches.com>
	 <201001312132.19798.elendil@planet.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 12:38:42 -0800
Message-ID: <1264970322.25140.175.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-31 at 21:32 +0100, Frans Pop wrote:
> If that spacing part is really needed (is it?), wouldn't it be more
> readable as:
> > +		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu"
> > +				" 				"
> > +				"%4lu %4lu %4lu %4lu %4lu",  
> > +				allocs, high, grown,

If it's required (most likely not, but it's a seq_printf and
some people think those should never be modified because it's
a public interface), it should probably be explicit:

" : globalstat %7lu %6lu %5lu %4lu \t\t\t\t%4lu %4lu %4lu %4lu %4lu"



