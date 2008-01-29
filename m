Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbYA2APU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbYA2APU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 19:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYA2APH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 19:15:07 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:51366 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYA2APF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 19:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WgX0r8sMDVSVseYGWsm5x5E1AmJ47jEBSYiEdFo7jGN1JjIj+Wbu4uuOYzKe+JCWpGi8i69ObuLp/gdYUX1CFJ6+H2X+PAeZaOSY0+AMl/whXmnkRW5JlEii/AwjQx4PDpfmDS8o8CMjOrpJkTyCfHBYaW0xKwaQGS1wbkmLvM8=
Message-ID: <8bd0f97a0801281615w6fbdd77aifda714685f56cc41@mail.gmail.com>
Date: Mon, 28 Jan 2008 19:15:01 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Daniel Barkalow" <barkalow@iabervon.org>
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging purposes
Cc: "richard kennedy" <richard@rsk.demon.co.uk>, bryan.wu@analog.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <cooloney.lkml@gmail.com>
In-Reply-To: <alpine.LNX.1.00.0801281901130.13593@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
	 <1201516811.7547.46.camel@roc-laptop>
	 <8bd0f97a0801280306k5dc4410eu208bc55f1975ceb8@mail.gmail.com>
	 <479DD2F3.6020209@rsk.demon.co.uk>
	 <8bd0f97a0801280510q42dbf5d3i947877b7e3454fe1@mail.gmail.com>
	 <alpine.LNX.1.00.0801281901130.13593@iabervon.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 7:08 PM, Daniel Barkalow <barkalow@iabervon.org> wrote:
> On Mon, 28 Jan 2008, Mike Frysinger wrote:
> > On Jan 28, 2008 8:04 AM, richard kennedy <richard@rsk.demon.co.uk> wrote:
> > > there is a lot of duplication in your file, but you could slim it down a
> > > bit if thats the only objection.
> >
> > i imagine there's a ton of duplication ... the file is auto-generated
> > from XML files, so i could take a look at the autogeneration producing
> > unified code.
>
> Could you submit the XML files and the autogeneration code? The C file
> isn't really source. Not only is it big, it'll probably change around a
> whole lot when you make small changes to your process, be hard to review,
> etc.

that would require the build system to have xml tools installed ...
that doesnt sound pleasant.

that said, the XML files in question are probably 10x+ the size of the
C file.  swapping 1 meg for 10+ megs ? :)
-mike
