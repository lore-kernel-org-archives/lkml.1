Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbYBSVDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbYBSVDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYBSVDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:03:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:37943 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbYBSVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:03:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=GXrBOm+ZJCkB5VIUuWtkwdBklyAIyHXXBBe5HirEvaLr9GwtbNsECQmEIbR7L7uf0QgsbSVW8pKmuOU2h07/jgyW10+tspFg4McB+/faWkt4tEJFAxNduHejh3rCDI9+yeMh+HS6q7oh94ufrAktwC2EUh71PsoZSs8jUBn7rNE=
To: chris2553@googlemail.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Tue, 19 Feb 2008 22:03:03 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802192046.14184.IvDoorn@gmail.com> <200802192044.52327.chris2553@googlemail.com>
In-Reply-To: <200802192044.52327.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192203.03741.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > I've tried the patch but, unfortunately, my wireless LAN still dies after a few pings.
> > 
> > Could you use below patch instead, and make a new dump of the register?
> > I'm still convinced the breakage occurs in the antenna diversity (or rather, I believe
> > it attempts a software diversity for your card while in fact it shouldn't).
> > 
> 
> Sorry, I've applied that patch and the LAN still dies after a few pings. BTW,

> this and the earlier patch both apply without error, but give warnings of 70
> line offsets. Were you expecting them to apply completely cleanly? I'm just
> wondering if there might be some code that you are expecting to be running (or
> not running) that is (or is not) present in the driver at 2.6.25-rc2.

Well to be honest I based the patch on rt2x00.git and not 2.6.25-rc2.
I know the patch would apply safely because the function that were changed
in that patch haven't changed between them. But some other functions were
moved. So that offset is correct. ;)

> The register dumps before and after are attached.

Thanks. I hope to have a new patch ready soon.

Ivo

