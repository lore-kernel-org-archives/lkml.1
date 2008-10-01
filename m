Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYJAKGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYJAKGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 06:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYJAKGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 06:06:23 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:52961 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbYJAKGX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 06:06:23 -0400
Subject: Re: [PATCH] slub: reduce total stack usage of slab_err & object_err
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       penberg <penberg@cs.helsinki.fi>, mpm <mpm@selenic.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080930193318.GA31146@logfs.org>
References: <1222787736.2995.24.camel@castor.localdomain>
	 <20080930193318.GA31146@logfs.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 01 Oct 2008 11:06:07 +0100
Message-Id: <1222855567.3052.31.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 21:33 +0200, Jörn Engel wrote:
> On Tue, 30 September 2008 16:15:36 +0100, Richard Kennedy wrote:
> > 
> > I've been trying to build a tool to estimate the maximum stack usage in
> > the kernel, & noticed that most of the biggest stack users are the error
> > handling routines.
> 
> Cool!  I once did the same, although the code has severely bitrotted by
> now.  Is the code available somewhere?
> 
> Jörn

No I haven't made it available as it's really only a proof of concept,
and I still don't have any sensible ideas how to deal with pointers to
functions. Plus I'm still testing it to see if the results are anything
like reasonable.
Also it's finding lots of potentially recursive code paths and my
heuristic to deal with them is very basic. I'm just adding a feature so
that I can ignore some code paths, so maybe that will help.

Richard

