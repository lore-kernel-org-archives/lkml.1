Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYJVUbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYJVUbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYJVUbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:31:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:37515 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbYJVUbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:31:18 -0400
Date: Wed, 22 Oct 2008 13:31:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       johannes@sipsolutions.net, davem@davemloft.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] fix WARN() for PPC
Message-ID: <20081022133102.5bd6e369@infradead.org>
In-Reply-To: <48FF8BB9.7050506@goop.org>
References: <20081020145056.24d84992@infradead.org>
	<48FF8BB9.7050506@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 13:23:21 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Arjan van de Ven wrote:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Mon, 20 Oct 2008 14:41:03 -0700
> > Subject: [PATCH] fix WARN() for PPC
> >
> > powerpc doesn't use the generic WARN_ON infrastructure.
> 
> Hm, why's that now?  The generic infrastructure was taken from
> powerpc, and I thought I'd converted it...
> 

it uses a BUG like trap rather than the normal WARN_ON() being a
function call to lib/bug.c


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
