Return-Path: <linux-kernel-owner+w=401wt.eu-S940502AbXGaFNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940502AbXGaFNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbXGaFMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:12:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:17125 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbXGaFMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bozvx2cYw1dRRYdGnLMztLA14Vm0P61+GB6FTL2rM+5/5xWCdwuM4reg4y0veHojzioWUf4hpZy7PHR2J3dPjsAxlQ5HOFb4FK/P6DDTvD5T1Ows2fFyJ4pPAOAXzme7KhMO/EQ1a5dPjv1sEfkW040cerDVEKdR0TBBwCkteRM=
Message-ID: <12c511ca0707302212o3702789bt8d597ec53a389e0a@mail.gmail.com>
Date: Mon, 30 Jul 2007 22:12:51 -0700
From: "Tony Luck" <tony.luck@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: regression on HP zx1 platform from ACPI autoload modules patches
Cc: "Doug Chapman" <doug.chapman@hp.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-ia64@vger.kernel.org, trenn@suse.de
In-Reply-To: <6bffcb0e0707301607x5484f114q9117007d131f7118@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1185836238.31298.36.camel@deimos.americas.hpqcorp.net>
	 <6bffcb0e0707301607x5484f114q9117007d131f7118@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > During bootup it panics with:
> >
> > Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or DIG kernel

I think that the fix for this has already gone into Linus's tree (on
Friday).  Commit SHA1
for the patch that should fix this is:
8c8eb78f673c07b60f31751e1e47ac367c60c6b7

If latest GIT tree still has this problem, then please let us know.

-Tony
