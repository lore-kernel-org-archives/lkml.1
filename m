Return-Path: <linux-kernel-owner+w=401wt.eu-S1761129AbZFKDKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129AbZFKDKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZFKDKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:10:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32845 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbZFKDKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:10:08 -0400
Date: Thu, 11 Jun 2009 04:10:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Amerigo Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.31 -mm merge plans
Message-ID: <20090611031005.GU8633@ZenIV.linux.org.uk>
References: <20090610115140.09c9f4cb.akpm@linux-foundation.org> <20090610190841.GT8633@ZenIV.linux.org.uk> <20090610121633.d678fc8b.akpm@linux-foundation.org> <4A305A99.70701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A305A99.70701@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 09:15:05AM +0800, Amerigo Wang wrote:
> Hi, Al.
>
> Just as what I said in the description of that patch, one only has  
> extern functions that are _only_ used in another as function pointers.

Er...  So what?  Amount of functions made static is not, per se, a
useful metrics of anything.

> And the size of code can't be a reason why they are seperated, we have
> much more source files larger than this one. :)

And that's not a good thing...
