Return-Path: <linux-kernel-owner+w=401wt.eu-S2993129AbXCIPwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993129AbXCIPwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993127AbXCIPwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:52:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992839AbXCIPwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:52:40 -0500
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
References: <1173419792.32234.131.camel@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2007 17:52:00 +0100
In-Reply-To: <1173419792.32234.131.camel@localhost.localdomain>
Message-ID: <p733b4ebbrj.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> __builtin_types_compatible_p() has been around since gcc 2.95, and we
> don't use it anywhere.  This patch quietly fixes that.

Using BUILD_BUG_ON_ZERO() would have been somewhat cleaner.

-Andi
