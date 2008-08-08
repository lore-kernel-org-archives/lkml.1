Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYHHAHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYHHAHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYHHAHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:07:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYHHAHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:07:23 -0400
Date: Thu, 7 Aug 2008 17:06:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: ehabkost@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make PFN_PHYS return a properly-formed physical address
Message-Id: <20080807170617.79ca3ce7.akpm@linux-foundation.org>
In-Reply-To: <489B8908.2010007@goop.org>
References: <489B6B40.5050705@goop.org>
	<20080807145648.ab3dfa90.akpm@linux-foundation.org>
	<489B72C3.30603@goop.org>
	<20080807162741.8dfcd336.akpm@linux-foundation.org>
	<489B8908.2010007@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2008 16:45:12 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Shall we go with just using plain u64 (or unsigned long long if we want 
> a really consistent type) in the meantime, and then waffle about 
> introducing a new type everywhere?
> 
> Or we could redefine resource_size_t to be big enough to refer to any 
> resource, including all memory.  It's close to being that anyway.

We could do

	typedef resource_size_t jeremy_thing_t;

for now and worry about it later if the need arises, perhaps.
