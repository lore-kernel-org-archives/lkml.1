Return-Path: <linux-kernel-owner+w=401wt.eu-S1760913AbYFWTMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913AbYFWTMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbYFWTMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:12:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:25971 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbYFWTMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Aa7r6g5BvOttqal0+rlOTBdyctCY0aCRPPZbG5GMau81OXaN8J5GWtPg4vfMTjmzyy
         ghpDHnbIHidjOlqsk5cXOmFHpQLHzj1r60gjM2T4bVDZVrtvPIepvJAiTJeLNDfm/ASG
         6WbB3z6O6vFzPIWGvdgma6Wbp29os668rXAyE=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Date: Mon, 23 Jun 2008 21:12:30 +0200
User-Agent: KMail/1.8.2
Cc: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>
References: <1209577322.25560.402.camel@pmac.infradead.org> <200806231922.10864.vda.linux@googlemail.com> <20080623185728.GB30550@uranus.ravnborg.org>
In-Reply-To: <20080623185728.GB30550@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806232112.30393.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 20:57, Sam Ravnborg wrote:
> > > I agree. And if we do want to pay attention to pure code size, there are
> > > other approaches -- like --gc-sections
> > 
> > I have some patches in this area too. Were submitted to Sam
> > but he was too busy it seems.
>
> They were not trivial to apply and so went down on the TODO list.

I realize that they were not trivial to review, but that
was unavoidable. They were even more not trivial to create.

> We could try to push the generic and x86 specific .lds stuff via
> the arch maintainers?

IIRC I splitted the entire GC collection patch in a way
that first patches were doing exactly this easier first part
and I hoped that at least these first patches
will be taken. They were big, but somewhat trivial,
from "it's obviously safe" department.

Had they been applied, now making --gc-sections to work
would be easier.
--
vda

