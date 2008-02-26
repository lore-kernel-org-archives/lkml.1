Return-Path: <linux-kernel-owner+w=401wt.eu-S1760367AbYBZEWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367AbYBZEWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbYBZEWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:22:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21269 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYBZEWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:22:40 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=J157QlDoNhTbdzA/zYt99htUmcvRInVXQiz3bwZEfWDpsBod4A1OIWwA0SHAnLZm4
	oNRfDreSUc78NOqCXiCwg==
Date: Mon, 25 Feb 2008 20:21:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
In-Reply-To: <20080225220242.82aedaec.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802252017310.14627@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <20080225212056.ca388983.pj@sgi.com> <alpine.DEB.1.00.0802251931030.6021@chino.kir.corp.google.com> <20080225220242.82aedaec.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Paul Jackson wrote:

> Eh ... each bit of added clarity to the code reduces
> errors.
> 
> Looking around the kernel, it really seems to me to be
> a common coding to explicitly spell out enum values
> when for some reason they actually matter.
> 
> Like most coding mechanisms, nothing guarantees anything.
> 
> It just nicely represents one particular detail, that
> the values of these MPOL_* terms are not arbitrary.
> 

Of course the MPOL_* modes aren't arbitrary; they are defined in an enum 
that has a well-defined and explicit behavior for how they are mapped to 
int values based on a standard.

I have more mempolicy patches that add additional behavior and cleanups so 
I can queue the following for a later posting.  I'd like to avoid 
respinning this set unless there are actual design or implementation 
concerns that are raised. 
---
 include/linux/mempolicy.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -20,7 +20,9 @@ enum {
 	MPOL_PREFERRED,
 	MPOL_BIND,
 	MPOL_INTERLEAVE,
-	MPOL_MAX,	/* always last member of enum */
+	/* add additional MPOL_* modes here */
+
+	MPOL_MAX,
 };
 
 /* Flags for set_mempolicy */
