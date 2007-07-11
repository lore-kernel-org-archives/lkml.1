Return-Path: <linux-kernel-owner+w=401wt.eu-S934541AbXGKX0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541AbXGKX0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbXGKX0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:26:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:32608 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbXGKX0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:26:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GGPSfqwXrpoZ/0IPazhY4Cf+1amFLHFJ2RFnR08uBsKCOeeCx9gAgXpmLo42MCaz2dL6uuBS2Bydbu//h2XnNjJHCDyrUiGQWbRzPNyInITtOhOX0YNxO5N7cVL+Pu93KhaW9MjejAdm7SsG+GplvKyJ1MmgikxNTCB8GMPrSFI=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] vsprintf.c: optimizing, part 2: base 10 conversion speedup, v2
Date: Thu, 12 Jul 2007 01:26:13 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>
References: <200707051251.52891.vda.linux@googlemail.com> <20070705143419.f214f5b2.akpm@linux-foundation.org>
In-Reply-To: <20070705143419.f214f5b2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707112326.13565.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2007 21:34, Andrew Morton wrote:
> On Thu, 5 Jul 2007 12:51:52 +0200
> Denis Vlasenko <vda.linux@googlemail.com> wrote:
> 
> > Using code from
> > 
> > http://www.cs.uiowa.edu/~jones/bcd/decimal.html
> > (with permission from the author, Douglas W. Jones)
> 
> Neither of your patches had signed-off-by:s.  Would prefer that they were
> included please, given that we're adding stuff from someone's website.

Sorry. Consider this added to both patches:

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Yes. "Denys" is how Ukrainian bureaucracy insists on spelling my name.
This Signed-off-by thing is official, so here it goes.
Informally please use "Denis".
--
vda
