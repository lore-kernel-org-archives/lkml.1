Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbXH2Ejm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbXH2Ejm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbXH2Ejc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:39:32 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:18276 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbXH2Ejb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=rZJG2tv989/oE/4H174QyxZ2tKnro9wNa/pj8yBvyd4U+YNH82OcZTSpkMyD7BGhFccg9OHzeGatFWfhOX6b62vklurOxi/VOW8kuRRtpbVYEJjmn06FdrcmjktGp7sj4H0kQ+ddAGUy9rHPFM0j5ortmsPXTqcVKWHkOQZxEQA=
Date: Wed, 29 Aug 2007 08:39:21 +0400
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, torvalds@osdl.org, len.brown@intel.com,
       ak@suse.de, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.23-rc4: maxcpus still broken
Message-ID: <20070829043921.GA1765@martell.zuzino.mipt.ru>
References: <20070828111431.GA27707@localhost.sw.ru> <6bffcb0e0708281635v2fdca60bv40099d0583599637@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0708281635v2fdca60bv40099d0583599637@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 01:35:57AM +0200, Michal Piotrowski wrote:
> On 28/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> > Every time I try to boot with maxcpus=1 it dies show_stat():
> 
> Is this a regression?

yep

> Hugh fixed some issues on x86-64 commit 813409771731d80e6fa94199adf99f2269a4afc0

This is 2.6.23-rc4, which has this fix, yes.

And I have second box with exactly same behaviour: x86_64 E6400, it also has ACPI=n
Turning on ACPI doesn't make it any better, though.
