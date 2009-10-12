Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbZJLLgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbZJLLgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756219AbZJLLgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:36:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2072 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbZJLLgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:36:09 -0400
Subject: Re: [PATCH 2/3] MAINTAINERS: Document new "K:" entry type
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <alpine.LRH.2.00.0910121211250.12171@twin.jikos.cz>
References: <cover.1255153863.git.joe@perches.com>
	 <6773e26fed99c1e686bf6efa3dd59eba525c7633.1255153863.git.joe@perches.com>
	 <alpine.LRH.2.00.0910121211250.12171@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 04:35:31 -0700
Message-Id: <1255347331.1839.41.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 12:14 +0200, Jiri Kosina wrote:
> On Fri, 9 Oct 2009, Joe Perches wrote:
> > +	K: Keyword perl extended regex pattern to match content in a
> > +	   patch or file.  For instance:
> > +	   K: of_get_profile
> > +	      matches patches or files that contain "of_get_profile"
> > +	   K: \b(printk|pr_(info|err))\b
> > +	      matches patches or files that contain one or more of the words
> > +	      printk, pr_info or pr_err
> What expressions do you expect people will be using here?

Keywords or keyword initiators specific to a facility
that's used kernel-wide.

> (the example with printk() doesn't really demonstrate usefulness of this).

A useful, simple example would be cheerfully substituted.
maybe:
	K: \b(AUDIT|audit)_

