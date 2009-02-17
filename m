Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZBQUMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZBQUMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZBQUMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:12:25 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42985 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751253AbZBQUMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:12:25 -0500
Date: Tue, 17 Feb 2009 15:04:51 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch] SLQB slab allocator (try 2)
In-Reply-To: <84144f020902171143i5844ef83h20cb4bee4f65c904@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0902171504090.24395@qirst.com>
References: <20090123154653.GA14517@wotan.suse.de>  <200902041748.41801.nickpiggin@yahoo.com.au>  <20090204152709.GA4799@csn.ul.ie>  <200902051459.30064.nickpiggin@yahoo.com.au>  <20090216184200.GA31264@csn.ul.ie> <4999BBE6.2080003@cs.helsinki.fi> 
 <alpine.DEB.1.10.0902171120040.27813@qirst.com>  <1234890096.11511.6.camel@penberg-laptop>  <alpine.DEB.1.10.0902171204070.15929@qirst.com>  <20090217181157.GA2158@cmpxchg.org> <84144f020902171143i5844ef83h20cb4bee4f65c904@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009, Pekka Enberg wrote:

> >> +#define SLUB_MAX_SIZE (2 * PAGE_SIZE)
>
> On Tue, Feb 17, 2009 at 8:11 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > This relies on PAGE_SIZE being 4k.  If you want 8k, why don't you say
> > so?  Pekka did this explicitely.
>
> That could be a problem, sure. Especially for architecture that have 64 K pages.

You could likely put a complicated formula in there instead. But 2 *
PAGE_SIZE is simple and will work on all platforms regardless of pagesize.

