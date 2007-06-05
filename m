Return-Path: <linux-kernel-owner+w=401wt.eu-S1762406AbXFEAy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762406AbXFEAy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 20:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXFEAyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 20:54:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:39287 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbXFEAyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 20:54:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sqTMvya4m3oHZGQNhMWEE04uxwBDifxi4t7bK8/5N8TAKzm2PKeRSJ8Li20eqtu5xAOwN6zUMYnevPedvTDpUkRdfyUaUkFb3svI/52wOB+35VoOwIGIa+leXn9YrFCucFuwZy91u+/MrCdDsgl7DIjM02VdVHUulYM5+waaeW4=
Message-ID: <86802c440706041754h2d7fe950ge5ea4c41146bdf97@mail.gmail.com>
Date: Mon, 4 Jun 2007 17:54:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Cc: "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070604192323.GA14844@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan>
	 <200706011407.51779.jbarnes@virtuousgeek.org>
	 <20070601211943.GO7217@one.firstfloor.org>
	 <200706011441.57149.jbarnes@virtuousgeek.org>
	 <m1r6orwptz.fsf@ebiederm.dsl.xmission.com>
	 <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan>
	 <20070604192323.GA14844@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Andi Kleen <andi@firstfloor.org> wrote:
> > From their e-mail:
> >
> > Note before continuing: Debian* Linux Operating System is not an
> > officially, validated, tested Operating System for the Intel(R) Desktop
> > Board DG965WH
> > (see http://downloadcenter.intel.com/Product_Filter.aspx?ProductID=2375);
> > moreover, we do confirm that "on a system that has 8 GB of system memory
> > installed, it is not possible to use all of the installed memory due to
> > system address space being allocated for other system critical functions."
> > [qtd. on page 43 of the Technical Product Specification (see
> > http://download.intel.com/design/motherbd/wh/D5600801US.pdf)].  Thus, the
> > following suggestions are provided AS IS; we cannot guarantee the problem
> > would be fixed afterwards:
>
> They're talking about something different than your issue. If you put in
> the fully possible 8GB (4x2GB) then some memory will be lost to the PCI hole
> because the desktop ICH can only access 35bits (8GB) in hardware.
>
> That can be up to 2GB in extreme cases, usually <0.5-1GB depending
> on how much mapping space your hardware needs.
>
> But if you put in less than 8GB the BIOS is supposed to remap
> the memory around the PCI hole and set up the MTRRs correctly
> so that the PCI hole is uncached and the memory around it is cached.
>
> That is 100% the BIOS' responsibility and if it doesn't do that
> it is buggy.

then the BIOS need to disable mem remap to make thing simple if there
8G ram installed.

YH
