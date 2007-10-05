Return-Path: <linux-kernel-owner+w=401wt.eu-S1763958AbXJEUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763958AbXJEUoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760911AbXJEUoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:44:06 -0400
Received: from gw.goop.org ([64.81.55.164]:43299 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758575AbXJEUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:44:05 -0400
Message-ID: <4706A20A.5060603@goop.org>
Date: Fri, 05 Oct 2007 13:43:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bbpetkov@yahoo.de, linux-kernel@vger.kernel.org, muli@il.ibm.com,
       satyam@infradead.org, amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
References: <20070918194647.GA23800@gollum.tnic> <20071005124705.6584e2f9.akpm@linux-foundation.org>
In-Reply-To: <20071005124705.6584e2f9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
>
> Now that we have DMA_BIT_MASK(), these macros are pointless.
>   

Except, unfortunately, DMA_64BIT_MASK.  I guess we could special case
it, assuming this works in all the contexts the macro is used in (ie,
compile-time constant?):

#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))



    J
