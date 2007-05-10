Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbXEJTY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbXEJTY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbXEJTYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:24:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53330 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753201AbXEJTYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:24:20 -0400
Date: Thu, 10 May 2007 12:24:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC] Slab allocators: Drop support for destructors
In-Reply-To: <84144f020705101221y6070ed93he837c59053084fae@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705101223010.10935@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705101156190.10663@schroedinger.engr.sgi.com>
 <84144f020705101221y6070ed93he837c59053084fae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Pekka Enberg wrote:

> > Or do we want to continue support destructors? If so why?
> 
> Well, constructors are on their way out too because they don't seem to
> give the performance benefit they were designed for anymore. As for
> destructors, they have been pretty useless in Linux for a long time
> now and we really don't do much "complex initialization" that requires
> undo (releasing resources).

Well I am not too sure about removing constructors. Andrew's test seems to 
show some benefit. That is just one test though. We need more. I do not 
like constructors either but if performance tests show regressions then we 
need to keep them.

