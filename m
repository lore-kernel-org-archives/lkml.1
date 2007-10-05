Return-Path: <linux-kernel-owner+w=401wt.eu-S1764198AbXJEVX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764198AbXJEVX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXJEVXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:23:51 -0400
Received: from gw.goop.org ([64.81.55.164]:44498 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbXJEVXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:23:50 -0400
Message-ID: <4706AB5D.4060602@goop.org>
Date: Fri, 05 Oct 2007 14:23:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Andrew Morton <akpm@linux-foundation.org>, bbpetkov@yahoo.de,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, satyam@infradead.org,
       amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
References: <20070918194647.GA23800@gollum.tnic> <20071005124705.6584e2f9.akpm@linux-foundation.org> <4706A20A.5060603@goop.org> <20071005140050.655b7727.akpm@linux-foundation.org> <Pine.LNX.4.64.0710051701530.12079@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0710051701530.12079@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> or you could take advantage of the macros in kernel.h and write that
> as:
>
> +#define DMA_BIT_MASK(n)      (((n) == 64) ? ULLONG_MAX : ((1ULL<<(n))-1))
>   

But that's a more indirect way of expressing "I want all 1's".

    J
