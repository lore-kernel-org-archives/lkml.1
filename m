Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbYADNYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbYADNYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYADNYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:24:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:58925 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYADNYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BSXd/PnKwQRZFIz/c3DePXRnUc1+p+u9xaIwntJ8mXN+cKnu+N4sJ3Zhr1kS7PManTqEhJITvAc4jVgt+Mz0PGRX7Rjdv+NQzw/9P3wn3xxBsdep6bDLHYKblbZ6EWNfB1draGkZxgtja8s45uHRkhV7W183W6quyeR2IeRb1/g=
Date: Fri, 4 Jan 2008 14:30:31 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       netdev@vger.kernel.org, Tom Tucker <tom@opengridcomputing.com>
Subject: Re: 2.6.24-rc6-mm1
Message-ID: <20080104133031.GA3329@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0801040223q17a76565k3c7667a197403ce5@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-01-2008 11:23, Torsten Kaiser wrote:
> On Jan 2, 2008 10:51 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Wed, Jan 02, 2008 at 07:29:59PM +0100, Torsten Kaiser wrote:
>>> Vanilla 2.6.24-rc6 seems stable. I did not see any crash or warnings.
>> OK that's great.  The next step would be to try excluding specific git
>> trees from mm to see if they make a difference.
>>
>> The two specific trees of interest would be git-nfsd and git-net.
> 
> git-nfsd from git://git.linux-nfs.org/projects/bfields/linux.git#for-mm
> -> compiling and installing 54 packages worked without crashes.
> 
> git-net from git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.25.git
> -> compiling and installing 95 packages worked without crashes.
...
> I will enable CONFIG_IOMMU_DEBUG in -rc6-mm1 and see, as otherwise I
> have no clue where to look...

Hi,

A few questions/suggestions:

- is it still vanilla -rc6-mm1; I've seen on kernel list you tried
some fixes around raid?

- could you remind this lockdep warning; is it always and the same,
always before crash, or no rules?

- I've seen you looked after double freeing, but this last debug list
warning could suggest locking problems during list modification too.

- above git-nfsd and git-net tests should be probably repeated with
-rc6-mm1 git versions: so vanilla rc6 plus both these -mm patches
only, and if bug triggers, with one reversed; btw., since in previous
message you mentioned that 50 packages could be not enough to trigger
this, these 54 above could make too little margin yet.

Regards,
Jarek P.
