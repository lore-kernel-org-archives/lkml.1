Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZI3Phd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZI3Phd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZI3Phd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:37:33 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:65451 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbZI3Phc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YFWO/xhs0C4gu2Bq5noVqplRuudbFIlyW5+61UAdqZu7El3YUBYEwjLQi3uWMOs5hv
         cEnqalBg4H6ySdIhual+fQNX1iUkajxe3uyv2DhPOIME9t8/AVXHHqMUANs0Go9+h6YS
         UGvGp+IuJdFc8BhQz8KXu+YCzzL1RrBXdkBaE=
Date: Wed, 30 Sep 2009 17:37:30 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, david.graham@intel.com,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Message-ID: <20090930153730.GA2120@bizet.domek.prywatny>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909170118.53965.rjw@sisk.pl> <4AB29F4A.3030102@intel.com> <200909180027.37387.rjw@sisk.pl> <20090922233531.GA3198@bizet.domek.prywatny> <20090929135810.GB14911@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929135810.GB14911@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 02:58:11PM +0100, Mel Gorman wrote:
> On Wed, Sep 23, 2009 at 01:35:31AM +0200, Karol Lewandowski wrote:
> > Maybe I should revert following commits (chosen somewhat randomly)?
> > 
> > 1. 49255c619fbd482d704289b5eb2795f8e3b7ff2e
> > 
> > 2. dd5d241ea955006122d76af88af87de73fec25b4 - alters changes made by
> > commit above
> > 
> > Any ideas?
> > 
> 
> Those commits should only make a difference on small-memory machines.
> The exact value of "small" varies but on 32 bit x86 without PAE, it would
> be 20MB of RAM. The fact reverting the two patches makes any difference at
> all is a surprise and likely a co-incidence.
> 
> If you have a reliable reproduction case, would it be possible to bisect
> between the points
> d239171e4f6efd58d7e423853056b1b6a74f1446..b70d94ee438b3fd9c15c7691d7a932a135c18101
> to see if the problem is in there anywhere?

I've started with bc75d33f0 (one commit before d239171e4 in Linus'
tree) but then my system fails to resume.

Whatever I do (change fb/Xorg drivers, disable X, etc.) I always end
up with unusable display and something that looks like hard-locked
system (I haven't tested network connectivity from another box, but
console is surely dead).

Thanks.
