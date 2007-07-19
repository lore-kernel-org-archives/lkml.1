Return-Path: <linux-kernel-owner+w=401wt.eu-S965125AbXGSOIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125AbXGSOIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765673AbXGSNxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:53:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765679AbXGSNw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:52:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH for review] [31/48] i386: basic infrastructure support for AMD geode-class  machines
Date: Thu, 19 Jul 2007 15:47:38 +0200
User-Agent: KMail/1.9.6
Cc: dilinger@queued.net, david-b@pacbell.net, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070719317.317927000@suse.de> <20070719131756.4E41714E5F@wotan.suse.de> <20070719144136.4fd007ba@the-village.bc.nu>
In-Reply-To: <20070719144136.4fd007ba@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707191547.39131.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > +/* Specific geode tests */
> > +
> > +static inline int is_geode_gx(void)
> > +{
> > +	return ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC) &&
> > +		(boot_cpu_data.x86 == 5) &&
> > +		(boot_cpu_data.x86_model == 5));
> > +}
> 
> My docs imply this could also be 5,5,VENDOR_CYRIX ?
> 
> Mot sure it matters for the I/O stuff

I guess i'll wait for someone with that hardware to submit a tested patch.
Just changing it blind seems too risky.

-Andi
