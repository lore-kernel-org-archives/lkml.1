Return-Path: <linux-kernel-owner+w=401wt.eu-S970279AbXEHXfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970279AbXEHXfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969704AbXEHXen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:34:43 -0400
Received: from ozlabs.org ([203.10.76.45]:50995 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970197AbXEHXem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:34:42 -0400
Subject: Re: get_user_pages vs mmap MAP_FIXED bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <464029C2.1020003@yahoo.com.au>
References: <1178434876.12284.175.camel@localhost.localdomain>
	 <1178501204.7731.35.camel@localhost.localdomain>
	 <20070506202225.ba6476b6.akpm@linux-foundation.org>
	 <464029C2.1020003@yahoo.com.au>
Content-Type: text/plain
Date: Wed, 09 May 2007 09:34:29 +1000
Message-Id: <1178667269.7286.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-08 at 17:41 +1000, Nick Piggin wrote:
> Fancy that! Thanks for catching it Rusty, does the following work for
> you?

Hi Nick,

	After 24 hours, it seems to be holding up (the original problem showed
up in lguest, which uses get_user_pages extensively).

Thanks!
Rusty.


