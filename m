Return-Path: <linux-kernel-owner+w=401wt.eu-S933737AbXHXTK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbXHXTK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763515AbXHXTKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:10:42 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:16143 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbXHXTKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CIxl3F2J2uuDiG1xHd3l416BCw2vQXRRqNgw4xkTdh/6JE0XvsPDb2pxyTImnuzWWx+tcMEPsgE8VfyFKoC+cL7t7veS3wrsBbq3we4cFYOn24pyrZ1K5K3TzjWcx1PLaeev3ZnBriXuq1DpP1gup/uQX8Qd0dyVpZKkmPyNtME=
Message-ID: <8bd0f97a0708241210w52dd7dc5s9c3df342f8c39832@mail.gmail.com>
Date: Fri, 24 Aug 2007 15:10:40 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Josef Sipek" <jsipek@fsl.cs.sunysb.edu>
Subject: Re: false positive in checkpatch.pl (complex macro values)
Cc: "SL Baur" <steve@xemacs.org>, "Andy Whitcroft" <apw@shadowen.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <20070824164741.GB1875@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com>
	 <46CEC3D4.40805@shadowen.org>
	 <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
	 <8bd0f97a0708240624v64b47b4l726a66f9766bc4a0@mail.gmail.com>
	 <20070824164741.GB1875@filer.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, Josef Sipek <jsipek@fsl.cs.sunysb.edu> wrote:
> On Fri, Aug 24, 2007 at 09:24:17AM -0400, Mike Frysinger wrote:
> ...
> > $ grep AUREON_DEVICE_DESC ./sound/pci/ice1712/aureon.h -A 5
> > #define  AUREON_DEVICE_DESC            "{Terratec,Aureon 5.1 Sky},"\
> >                                        "{Terratec,Aureon 7.1 Space},"\
> >                                        "{Terratec,Aureon 7.1 Universe}," \
> >                                         "{AudioTrak,Prodigy 7.1}," \
> >                                         "{AudioTrak,Prodigy 7.1 LT},"\
> >                                         "{AudioTrak,Prodigy 7.1 XT},"
>
> This is a different thing. This is a long string, not a list of elements.
> IMO, this one shouldn't have given a warning regardless of whether or not
> the original case is valid.

i did point out that grepping the tree shows plenty of results ... if
this one is not satisfactory, you're free to grep to locate ones that
are

the code we're using is used to initialize a data structure ... you
can find similar things in:
./sound/ppc/tumbler.c
./sound/pci/emu10k1/p16v.c
./sound/pci/hda/patch_realtek.c
./sound/pci/hda/patch_si3054.c
./sound/usb/usbquirks.h
./sound/oss/sscape.c
and then i hit ctrl+c
-mike
