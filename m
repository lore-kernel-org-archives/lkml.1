Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbZEARnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbZEARnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755517AbZEARnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:43:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZEARnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:43:32 -0400
Date: Fri, 1 May 2009 13:43:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 32/35] Move users to asm-generic/ptemap.h
Message-ID: <20090501174331.GA8104@infradead.org>
References: <20090501144201.D31EF417@kernel> <20090501144251.62441D55@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501144251.62441D55@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 07:42:51AM -0700, Dave Hansen wrote:
> 
> Now that we have everyone using pte_offset_kernel(),
> we can plainy see that almost all the users are
> exactly the same.
> 
> This takes all of those users and moves them over to
> using asm-generic/ptemap.h instead.

s/users/implementations/g ?

Also asm-generic/ptemap.h really wants a comment when architectures
can use this generic version.

