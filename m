Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZAWPpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZAWPpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbZAWPob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:44:31 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52940 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbZAWPoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:44:30 -0500
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <200901240237.10522.nickpiggin@yahoo.com.au>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>
	 <200901240212.58829.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0901231025320.21692@qirst.com>
	 <200901240237.10522.nickpiggin@yahoo.com.au>
Date: Fri, 23 Jan 2009 17:44:28 +0200
Message-Id: <1232725468.6094.97.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 02:37 +1100, Nick Piggin wrote:
> However, I don't know if netperf udp 4K over loopback is totally
> realistic. Maybe real network drivers have different allocation patterns.
> If I were you I wouldn't be too hasty to make big changes based on that
> alone, if it could introduce regression in somewhere more important.

Yup, I'm putting it in linux-next to see if anything pops up. It's of
course possible that it will introduce regression somewhere but seeing
the hit SLUB is taking from the page allocator, I'm bound to think that
performance increase claims of commit
aadb4bc4a1f9108c1d0fbd121827c936c2ed4217 ("SLUB: direct pass through of
page size or higher kmalloc requests") don't hold anymore.

		Pekka

