Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXLNUfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXLNUfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:35:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbXLNUfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:35:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:24101 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbXLNUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:35:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qn2wBWO+ONVqxO6F33oSLJwv2frHFhzpUvIywk7aslZjGBpZoqRdPkPGxrLHhqtmfr0bbV4ECU+dppJ5G1jMH0MZopeoc4IX9jCj/GkLg2WYdRTvIT985y6KVCQBvkHMqDAt85xP1QsIA2P0lDXpnHq0MjHzzDsGEhck94L//3w=
Message-ID: <8bd0f97a0712141235h48c3062cl139e4c2883a815a9@mail.gmail.com>
Date: Fri, 14 Dec 2007 15:35:36 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert Schwebel" <r.schwebel@pengutronix.de>
Subject: Re: Working upstream toolchain for avr32?
Cc: "Adrian Bunk" <bunk@kernel.org>, hskinnemoen@atmel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071214202829.GN3851@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213195617.GF21616@stusta.de>
	 <20071214200318.GM3851@pengutronix.de>
	 <8bd0f97a0712141221o3a65a5efo40c19ab12f7078c6@mail.gmail.com>
	 <20071214202829.GN3851@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 3:28 PM, Robert Schwebel <r.schwebel@pengutronix.de> wrote:
> On Fri, Dec 14, 2007 at 03:21:45PM -0500, Mike Frysinger wrote:
> > > Is an upstream toolchain available which is able to build blackfin?
> >
> > binutils -- yes
> > uClibc -- yes (for FLAT)
> > gcc -- yes and no
> >
> > we have some pieces in gcc, but if you want an
> > up-to-date-tested-known-working combination, you can fetch
> > sources/binaries from:
> > http://blackfin.uclinux.org/gf/project/toolchain/frs
>
> Upstream plus a well defined patch stack with well documented patches
> would definitely be preferred here.

as you've been told in the past, the things are documented.  go read
the ChangeLog.bfin file.

> > we're working now to make sure that when gcc-4.3 is branched/released,
> > we're part of it
>
> Ah, that sounds pretty good! At the moment we still need three different
> toolchains to build u-boot, the kernel

maybe, if you're using different version of u-boot and the kernel.
but that isnt a good idea anyways.

> and the icebear tools, which is not very satisfying.

there's nothing we can do about this and you're complaining to the
wrong people.  icebear is a third party binary-only tool.  if you dont
like the way the third party does things, complain to the third party.
 or dont buy their product.

> An upstream-blessed toolchain would probably be
> progress.

we are upstream and we've given you blessed toolchains.
-mike
