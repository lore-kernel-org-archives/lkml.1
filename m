Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbXDME3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbXDME3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 00:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXDME3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 00:29:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:37095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXDME3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 00:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=N1ODpiLttNRScAsbVOAeaI8XQ3v8XPSrwAdY/x6f9cMz04AQzNBXOWWrHCFD7slF+MT+HCNDjLNcow6rEuYq4VHO9U5AfLIeu85NbG8Nni+6DUsfQylxDMIS5A9s1wHaSwgyFOOAz/wdTvakXA6PVbBH/pdySMoBHa3ekpd8X80=
Date: Fri, 13 Apr 2007 10:01:40 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: kernel-janitors@lists.osdl.org, linux-ia64@vger.kernel.org,
       discuss@x86-64.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [KJ][PATCH 02/03]ROUND_UP|DOWN macro cleanup in arch/ia64,x86_64
Message-ID: <20070413043140.GA9431@arun.site>
References: <20070412203140.GB9353@arun.site> <20070412211334.GA5892@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412211334.GA5892@intel.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:13 Thu 12 Apr     , Luck, Tony wrote:
> On Fri, Apr 13, 2007 at 02:01:40AM +0530, Milind Arun Choudhary wrote:
> > -	size = ROUNDUP(size, iovp_size);
> > +	size = ALIGN(size, iovp_size);
> 
> Why is "ALIGN" better than "ROUNDUP"?  I can't see any point
> to this change.
Its a janitorial work. I'm trying to celanup 
all the corners where ROUNDUP/DOWN & likes are defined.
Kernel.h currently has macros like ALIGN roundup DIV_ROUND_UP.
in this patch series I've added ALIGN_DOWN & round_down
[waiting for comments on the same.]

So as ALIGN macro does the same work as ROUNDUP,
      is at a common place
      & is accessible to everyone
it should be used instead...i think

-- 
Milind Arun Choudhary
