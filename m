Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYHCB66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYHCB66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 21:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYHCB6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 21:58:50 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35050 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYHCB6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 21:58:49 -0400
Date: Sat, 2 Aug 2008 19:58:48 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
Subject: No, really, stop trying to delete slab until you've finished making slub perform as well
Message-ID: <20080803015847.GD26461@parisc-linux.org>
References: <20080801182324.572058187@lameter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801182324.572058187@lameter.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 07:21:01PM -0700, Christoph Lameter wrote:
> - Add a patch that obsoletes SLAB and explains why SLOB does not support
>   defrag (Either of those could be theoretically equipped to support
>   slab defrag in some way but it seems that Andrew/Linus want to reduce
>   the number of slab allocators).

Do we have to once again explain that slab still outperforms slub on at
least one important benchmark?  I hope Nick Piggin finds time to finish
tuning slqb; it already outperforms slub.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
