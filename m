Return-Path: <linux-kernel-owner+w=401wt.eu-S1422731AbXBURvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422731AbXBURvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422736AbXBURvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:51:54 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40167 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422731AbXBURvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:51:53 -0500
Date: Wed, 21 Feb 2007 09:51:51 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jsipek@fsl.cs.sunysb.edu,
       unionfs@filesystems.org, bunk@stusta.de, hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/3] slab: introduce krealloc
In-Reply-To: <84144f020702210133k4a9f40f0mc0f51524fac9c524@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702210951350.24344@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI> 
 <1172049875.3531.169.camel@laptopd505.fenrus.org>
 <84144f020702210133k4a9f40f0mc0f51524fac9c524@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka Enberg wrote:

> On 2/21/07, Arjan van de Ven <arjan@infradead.org> wrote:
> > please mark this one __must_check.. not storing realloc() return values
> > is one of the more nasty types of bugs... but gcc can help us greatly
> > here ;)
> 
> So I guess we want the same thing for the other allocator functions
> (__kmalloc et al) as well?

I think so.

