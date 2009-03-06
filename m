Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZCFTLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZCFTLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZCFTLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:11:10 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:63263 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbZCFTLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:11:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K1Sg1QMDHPMnfEHyygq0edMSnYxPe5UbbHjSpNKEmP3mN/PphRbiXtUUXoD2PyaWl9
         GSRPLI7wROa+xfUGk74hE8HUp5yTTywRduqtHQ3ptc6AY1M/XOGJ/n6R+fz+lH1pHA6b
         jK9YGnF82QoCs+nDtoZzgqItibvytQz5xqFOg=
Date: Fri, 6 Mar 2009 20:11:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 03/18] dma-debug: add hash functions for
	dma_debug_entries
Message-ID: <20090306191059.GE7329@nowhere>
References: <1236346229-6618-1-git-send-email-joerg.roedel@amd.com> <1236346229-6618-4-git-send-email-joerg.roedel@amd.com> <20090306135052.GE5988@nowhere> <20090306184514.GE7420@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306184514.GE7420@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:45:14PM +0300, Cyrill Gorcunov wrote:
> [Frederic Weisbecker - Fri, Mar 06, 2009 at 02:50:52PM +0100]
> ...
> | > +/*
> | > + * Add an entry to a hash bucket
> | > + */
> | > +static void hash_bucket_add(struct hash_bucket *bucket,
> | > +			    struct dma_debug_entry *entry)
> | > +{
> | > +	list_add_tail(&entry->list, &bucket->list);
> | > +}
> | > +
> | > +/*
> | > + * Remove entry from a hash bucket list
> | > + */
> | > +static void hash_bucket_del(struct dma_debug_entry *entry)
> | > +{
> | > +	list_del(&entry->list);
> | > +}
> | 
> | 
> | Perhaps the two wrappers above are unnecessary, since they are actually
> | used once and only wrap a single list operation. No?
> | 
> | Frederic.
> 
> Hi Frederic,
> 
> I think it would be better to make them 'inline' only but remain
> the wrappers as is, since it show logic flow and hides internal data
> details. But it's my personal opinion.


Yeah, I guess it's only a matter of taste :-)
Anyway, as you said, it should be inlined.

 
> | 
> ...
> 
> 	- Cyrill -

