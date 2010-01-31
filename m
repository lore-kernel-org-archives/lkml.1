Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0AaXxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:53:48 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:65330 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324Ab0AaXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:53:47 -0500
From: Frans Pop <elendil@planet.nl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 09/10] mm/slab.c: Fix continuation line formats
Date: Mon, 1 Feb 2010 00:53:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm@kvack.org
References: <cover.1264967493.git.joe@perches.com> <201001312132.19798.elendil@planet.nl> <1264970322.25140.175.camel@Joe-Laptop.home>
In-Reply-To: <1264970322.25140.175.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002010053.45818.elendil@planet.nl>
X-OriginalArrivalTime: 31 Jan 2010 23:53:46.0035 (UTC) FILETIME=[A055B830:01CAA2D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 January 2010, Joe Perches wrote:
> On Sun, 2010-01-31 at 21:32 +0100, Frans Pop wrote:
> > If that spacing part is really needed (is it?), wouldn't it be more
> >
> > readable as:
> > > +		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu"
> > > +				" 				"
> > > +				"%4lu %4lu %4lu %4lu %4lu",
> > > +				allocs, high, grown,
>
> If it's required (most likely not, but it's a seq_printf and
> some people think those should never be modified because it's
> a public interface), it should probably be explicit:
>
> " : globalstat %7lu %6lu %5lu %4lu \t\t\t\t%4lu %4lu %4lu %4lu %4lu"

Yes, would be better. And if it is kept for compatibility it probably 
deserves a comment explaining the weirdness.

Cheers,
FJP
