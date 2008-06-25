Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYFYPjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYFYPjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbYFYPjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:39:06 -0400
Received: from ozlabs.org ([203.10.76.45]:39637 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbYFYPjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:39:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] module: make symbol_put_addr() work for all exported symbols
Date: Thu, 26 Jun 2008 01:37:04 +1000
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       llipavsky@suse.cz
References: <alpine.LNX.1.10.0806191508020.4593@jikos.suse.cz> <200806231348.58317.rusty@rustcorp.com.au> <alpine.LNX.1.10.0806251034330.4593@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0806251034330.4593@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806260137.04707.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008 18:37:37 Jiri Kosina wrote:
> On Mon, 23 Jun 2008, Rusty Russell wrote:
> >    It might be better to centralize all these iterators, and create a
> > proper iterator function.  Any chance you could rewrite it on top of
> > this patch? (Lightly tested)
>
> Hi Rusty,

Hi Jiri,

> I see two options how to do this -- either I can make 'value' input
> parameter too, so that find_symbol_in_section() could perform lookup
> either according to address or according to name (whatever is specified in
> the passed struct find_symbol_arg), or I can do a completely new lookup
> function for address-wise lookups. What would you prefer? I don't have any
> strong preference either way.

A new lookup function (and hence a new structure) I think.  It'll be clearer.

Cheers,
Rusty.
