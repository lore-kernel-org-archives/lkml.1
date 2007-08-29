Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXH2QF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXH2QF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbXH2QFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:05:18 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:41284 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbXH2QFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:05:17 -0400
Date: Wed, 29 Aug 2007 17:04:26 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Oliver Neukum <oliver@neukum.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Daniel Drake <ddrake@brontes3d.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
In-Reply-To: <200708291636.48323.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0708291701140.617@blonde.wat.veritas.com>
References: <1188394172.22156.67.camel@localhost> <20070829073040.1ec35176@laptopd505.fenrus.org>
 <200708291636.48323.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007, Oliver Neukum wrote:
> Am Mittwoch 29 August 2007 schrieb Arjan van de Ven:
> > Another question, if this is during system shutdown, maybe that's a
> > valid case for flushing most of the pagecache first (from userspace)
> > since most of what's there won't be used again anyway. If that's enough
> > to make this go faster...
> 
> Is there a good reason to swapoff during shutdown?

Three reasons, I think, only one of them compelling:

1. Tidiness.
2. So swapoff gets testing and I get to hear of any bugs in it.
3. If a regular swapfile is used instead of a disk partition, you
   need to swapoff before its filesystem can be unmounted cleanly.

Hugh
