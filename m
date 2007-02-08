Return-Path: <linux-kernel-owner+w=401wt.eu-S1423331AbXBHUfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423331AbXBHUfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423327AbXBHUfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:35:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:38509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423331AbXBHUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:35:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l6YliAcxqFbKA4FLSCTSccTrp+5V/XAqtHXsmpVQRBPjfBF3tJUWBeOj3hItxEORuMSDzzr/unD2FzSbBhr0BjXhhGsbiJh6+VX8jcp3fnUOIwTJdD4Ku8dCk7VeZykPhakKE9epEzrj2PNwv/xIpG9AkORaCLQ2MSGkfFHQZr0=
Message-ID: <8bd0f97a0702081235v2e083301g49c1950fa61d8113@mail.gmail.com>
Date: Thu, 8 Feb 2007 15:35:34 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: + search-a-little-harder-for-mkimage.patch added to -mm tree
Cc: akpm@linux-foundation.org, sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070208202535.GX22699@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702080607.l1867c0D006861@shell0.pdx.osdl.net>
	 <E1HF9zs-0006Ei-2k@flower>
	 <8bd0f97a0702080628u5038191dm74139a7dd7bff909@mail.gmail.com>
	 <20070208202535.GX22699@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> On Thu, Feb 08, 2007 at 09:28:03AM -0500, Mike Frysinger wrote:
> > On 2/8/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> > >proposition is to substitute:
> > >     "$(CONFIG_SHELL) $(MKIMAGE)"
> > >with
> > >     "mkimage"
> >
> > this isnt a one-to-one change ... let's look at the typical
> > mkimage-missing scenario ...
>
> You are interested in presents of `mkimage', but yet we discussing its
> missing, or "Error -> Don't care" behavior.

i'm interested in having the system work for the Blackfin port and
that's it.  if people want to redefine the current standard of how
u-boot images are generated, then go for it and get the approval of
all the existing arches.

there's a difference between NACKing my changes because the patch
breaks things versus because you think the whole system should be
taking some other form.

so if you dont like the mkuboot.sh script, fine, have at it with
rewriting the system ... otherwise the patch i proposed should
continue on for inclusion.
-mike
