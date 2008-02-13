Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYBMXE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYBMXE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYBMXEC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:04:02 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:40271 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765441AbYBMXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:03:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=VXtGAjSSMycZF7IqjqWZEuC0TvmIMeFndSdqEEYTl6Xo3s97pMN8Pg4UvdMe7C6sdMJ0YafRiGPq3HN6m+fsTJnLpdIkeZAHPfPrE2TjKC99JOyfGU5TabQb7VfaRbgJ1tPFAvfb5UgwtoI9wjgPJdIiiNEUsXZ8ep7RNkRux+4=
Date: Thu, 14 Feb 2008 02:03:53 +0300
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits with 64b resources"
Message-ID: <20080213230353.GF2144@martell.zuzino.mipt.ru>
References: <20080204151222.GB25790@localhost.sw.ru> <200802132352.46948.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802132352.46948.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:52:46PM +0100, Rafael J. Wysocki wrote:
> On Monday, 4 of February 2008, Alexey Dobriyan wrote:
> > Commit c40a22e0ce5eb400f27449e59e43d021bee58b8d aka
> > "PCI: Fix bus resource assignment on 32 bits with 64b resources"
> > renders one tg3-equipped box networkless here.
> 
> Has it been fixed already or is it still happening with the current mainline?

It's fine now. See 20651af9ac60fd6e31360688ad44861a7d05256a aka
"x86: fix mttr trimming".
