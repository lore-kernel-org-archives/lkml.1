Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZBBJA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZBBJA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZBBJAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:00:19 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35566 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZBBJAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:00:18 -0500
Subject: Re: [patch] SLQB slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1233545923.2604.60.camel@ymzhang>
References: <20090121143008.GV24891@wotan.suse.de>
	 <Pine.LNX.4.64.0901211705570.7020@blonde.anvils>
	 <84144f020901220201g6bdc2d5maf3395fc8b21fe67@mail.gmail.com>
	 <Pine.LNX.4.64.0901221239260.21677@blonde.anvils>
	 <Pine.LNX.4.64.0901231357250.9011@blonde.anvils>
	 <1233545923.2604.60.camel@ymzhang>
Date: Mon, 02 Feb 2009 11:00:14 +0200
Message-Id: <1233565214.17835.13.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yanmin,

On Mon, 2009-02-02 at 11:38 +0800, Zhang, Yanmin wrote:
> Can we add a checking about free memory page number/percentage in function
> allocate_slab that we can bypass the first try of alloc_pages when memory
> is hungry?

If the check isn't too expensive, I don't any reason not to. How would
you go about checking how much free pages there are, though? Is there
something in the page allocator that we can use for this?

		Pekka

