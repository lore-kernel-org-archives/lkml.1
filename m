Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYBZGp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYBZGp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYBZGpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:45:46 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbYBZGpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:45:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=gDrVcUqG8xOHmA8GI9xt/9tw9itIwCdfEfZSuiN323d7oIsJ03DuLHUUbGdWI/Xg/
	1e0rUtRKdTIW9Fpkn5zpQ==
Date: Mon, 25 Feb 2008 22:45:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
In-Reply-To: <20080226001229.aea2f3d5.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802252245170.8527@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com> <20080226001229.aea2f3d5.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Paul Jackson wrote:

> David wrote:
> +static nodemask_t mpol_relative_nodemask(const nodemask_t *orig,
> +					 const nodemask_t *rel)
> +{
> +	nodemask_t ret;
> +	nodemask_t tmp;
> 
> Could you avoid needing the nodemask_t 'ret' on the stack, by passing
> in a "nodemask_t *" pointer to where you want the resulting nodemask_t
> written, rather than by returning it by value?
> 
>  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
> 					 const nodemask_t *rel)
> 

Done, thanks.
