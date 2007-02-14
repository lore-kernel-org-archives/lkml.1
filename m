Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbXBOANE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbXBOANE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932618AbXBOANE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:13:04 -0500
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:43214 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932607AbXBOAND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:13:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Lo8EBFBff4tlVDgkLhca8du6pGBsF6pehWuHqbQjM2pjvcRQ6AdgILOQCbcE0eYFtLwpSjYwUl0n46lLzGrcoJwVlNii+7i4M2yKNMo6eWJzher8Ub+EDq0ZbeB07pOOxdAgZvxLQT67/hJ+MRQzNE/vOKZyr5wHNo7ctWqQYiE=  ;
X-YMail-OSG: 4uqQG.wVM1neQUka3I8Hq2wcEWFcpM2y7RldkHuBNIMYMTG3ltem8iW2d2pvpdxalfoDFjo.VwnghFuWt_4aVMCH8opgcz._s81R7PSn5aaSO1fCOl87c39LWYDwzyGAK3fD9B8SrWchMhA-
From: David Brownell <david-b@pacbell.net>
To: Len Brown <lenb@kernel.org>
Subject: Re: loosen dependancy on rtc cmos
Date: Wed, 14 Feb 2007 15:47:35 -0800
User-Agent: KMail/1.7.1
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214180915.GA6412@redhat.com> <200702141155.33970.david-b@pacbell.net> <200702141820.33928.lenb@kernel.org>
In-Reply-To: <200702141820.33928.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141547.36106.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 3:20 pm, Len Brown wrote:
> > 
> > I still need to resubmit the patch, for X86_PC, which defines the platform
> > device in the (common) case where PNPACPI isn't defined.
> 
> CONFIG_PNPACPI=y is not the common case?

It's certainly not in the defconfig for x86-64.  And it's only been
three weeks since the CONFIG_EXPERIMENTAL dependency got removed.

So, no I would not think it's the common case.

- Dave
