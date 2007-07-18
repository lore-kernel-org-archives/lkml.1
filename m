Return-Path: <linux-kernel-owner+w=401wt.eu-S934881AbXGRWlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881AbXGRWlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934261AbXGRWkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:40:18 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:51872
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203AbXGRWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:40:16 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][Patch] Allow not mounting a root fs
Date: Wed, 18 Jul 2007 17:51:10 -0400
User-Agent: KMail/1.9.6
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Bodo Eggert <7eggert@gmx.de>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <Pine.LNX.4.64.0707072312380.1536@fbirervta.pbzchgretzou.qr> <469002EB.7030902@zytor.com>
In-Reply-To: <469002EB.7030902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181751.10276.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007 5:17:31 pm H. Peter Anvin wrote:
> Jan Engelhardt wrote:
> > On Jul 7 2007 13:56, H. Peter Anvin wrote:
> >> Jan Engelhardt wrote:
> >>> On Jul 5 2007 19:08, H. Peter Anvin wrote:
> >>>>> BTW: Is it possible to mount a tmpfs on / before extracting the cpio?
> >>>>
> >>>> Not in the stock kernel.  There have been some patches floating around
> >>>> for that, I think.
> >>>
> >>> What would it buy? rootfs is a tmpfs, is not it?
> >>
> >> No, rootfs is ramfs.
> >
> > Thanks for clarifying. Well, why is it a ramfs, and not tmpfs?
> > (I think I know the difference, but the question stands.
> > A system without any swap somewhat equals a ramfs, or?)
>
> It gets initialized very early, and a lot of the setup needed for tmpfs
> to work isn't ready yet.

Out of curiosity, do you know which setup?  I know that it won't actually swap 
anything out yet because no swap is mounted, but I thought that mounting 
tmpfs and doing a swapon afterwards was ok...

> 	-hpa

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
