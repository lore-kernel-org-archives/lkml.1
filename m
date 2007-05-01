Return-Path: <linux-kernel-owner+w=401wt.eu-S1423636AbXEAVJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423636AbXEAVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423644AbXEAVJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:09:26 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423636AbXEAVJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:09:24 -0400
Date: Tue, 1 May 2007 14:09:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
Message-Id: <20070501140911.1606a918.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705011345360.26494@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
	<20070501125559.9ab42896.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
	<20070501133618.93793687.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705011345360.26494@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 13:46:26 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 1 May 2007, Andrew Morton wrote:
> 
> > otoh I could do some frantic patch mangling and make it easier to carry
> > slub out-of-tree, but do we gain much from that?
> 
> Then we may loose all the slab API cleanups? Yuck. I really do not want 
> redo those....

No, I meant that I'd look at splitting those patches up into
one-against-mainline and one-against-slub.

