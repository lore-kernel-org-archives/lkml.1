Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYHCV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYHCV3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbYHCV3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 17:29:04 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45537 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbYHCV3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 17:29:03 -0400
Message-ID: <4896225D.9090203@cs.helsinki.fi>
Date: Mon, 04 Aug 2008 00:25:49 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Christoph Lameter <cl@linux-foundation.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org>
In-Reply-To: <20080803015847.GD26461@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Matthew Wilcox wrote:
> Do we have to once again explain that slab still outperforms slub on at
> least one important benchmark?  I hope Nick Piggin finds time to finish
> tuning slqb; it already outperforms slub.

No, you don't have to. I haven't merged that patch nor do I intend to do 
so until the regressions are fixed.

And yes, I'm still waiting to hear from you how we're now doing with 
higher order page allocations...

		Pekka
