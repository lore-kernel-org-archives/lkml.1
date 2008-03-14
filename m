Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbYCNQqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbYCNQqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 12:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYCNQqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 12:46:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:43434 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYCNQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 12:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I78XVNE7P4d/qcRdKZ/VtLGDqF3QY5R8ku78dLX/AUnBMlVjAGbhV1QiWDxTP7hPT/dW1Fv3BWxcPXm8BC4kZHGxiCV4pCM+pEsKU/A/Pn+W/odnAV+s1cz8yc2xp6hhjbJpAb9k36B2YT1gOz52uFpRhCrkvpfFZNnIydAJAHY=
Subject: Re: [PATCH 01/10] Add macros similar to min/max/min_t/max_t.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080314093451.cd3e644c.randy.dunlap@oracle.com>
References: <1205471926.19712.12.camel@brick>
	 <20080314093451.cd3e644c.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 09:46:11 -0700
Message-Id: <1205513171.27712.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-14 at 09:34 -0700, Randy Dunlap wrote:
> On Thu, 13 Mar 2008 22:18:45 -0700 Harvey Harrison wrote:

> Where is some blurb/comment about what "clamp" means/does?
> min/max are well understood, but clamp?  Is that a shop tool?
> I think I have a few out in my garage.
> 
> So can we have some blurb here to explain clamp(), clamp_t(),
> and clamp_val()?
> 
> (kernel-doc preferred, but not required) e.g:

> 
> /**
>  * clamp - returns a value that is restricted between min & max inclusive
>  * @val: current value
>  * @min: minimum value of the clamping region
>  * @max: maximum value of the clamping region
>  */
> 
> and explain the differences in clamp/clamp_t/clamp_val...
> 
> 

Sure, I'll do that..does kernel-doc actually work for macros?

Harvey


