Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYFWR2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYFWR2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 13:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbYFWR2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 13:28:11 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:50921 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbYFWR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 13:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=q7O+nPlXgNLdMAwEbiPy6NWkl82hxl+ZtsWrnwX6ZSwQsz82zn++Tun5AoG1asxL5w
         Os2W77BAN4pwltAQ4FVEWXlDpiDW2cRTy8UVgCnisfZkxKOxeDrMSwbxS7GnpXEAF6+i
         OBzXDBGiHgVVxm2wbi1FtO+ocZkdmz76Y8DBc=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Date: Mon, 23 Jun 2008 19:28:09 +0200
User-Agent: KMail/1.8.2
Cc: David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1209577322.25560.402.camel@pmac.infradead.org> <1209636171.25560.508.camel@pmac.infradead.org> <20080501104158.GM20451@one.firstfloor.org>
In-Reply-To: <20080501104158.GM20451@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231928.09458.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008 12:41, Andi Kleen wrote:
> > To a large extent, I agree. I certainly don't want to focus solely on
> > code size; there's a lot more to embedded Linux than that. But it _is_
> 
> Not only code size, far more important is dynamic memory consumption.
> [admittedly we right now lack a good instrumentation framework for this]
> 
> > There are some cases where we really _do_ want to have CONFIG options,
> > but I agree that we should keep them to a minimum. And when we _do_ have
> > CONFIG options, they don't have to litter the actual code with ifdefs.
> 
> The problem I see is more that really nobody can even compile not 
> alone test all these combinations anymore. Hidding the problem in inlines
> does not solve that. And no randconfig is not the solution either.

Because we allowed kernel to be developed without the requirement that
random config should be buildable for release kernels.

Had it been a requirement, keeping it in shape wouldn't be
too difficult.

Sure enough, _now_ fixing kernel to pass such a test on i386
would take several weeks of work at least. But it is doable.

I would even volunteer to do it if there are some
reasonable chances resulting patches would be viewed
as worthwhile for inclusion. I am somewhat tired
of killing weeks of my time only to find that my work
is deemed "not important enough for inclusion".
--
vda
