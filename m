Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbXHXQsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbXHXQsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXHXQrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:47:51 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53107 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbXHXQru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:47:50 -0400
Date: Fri, 24 Aug 2007 12:47:43 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: SL Baur <steve@xemacs.org>, Andy Whitcroft <apw@shadowen.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: false positive in checkpatch.pl (complex macro values)
Message-ID: <20070824164741.GB1875@filer.fsl.cs.sunysb.edu>
References: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com> <46CEC3D4.40805@shadowen.org> <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com> <8bd0f97a0708240624v64b47b4l726a66f9766bc4a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0708240624v64b47b4l726a66f9766bc4a0@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 09:24:17AM -0400, Mike Frysinger wrote:
...
> $ grep AUREON_DEVICE_DESC ./sound/pci/ice1712/aureon.h -A 5
> #define  AUREON_DEVICE_DESC            "{Terratec,Aureon 5.1 Sky},"\
>                                        "{Terratec,Aureon 7.1 Space},"\
>                                        "{Terratec,Aureon 7.1 Universe}," \
>                                         "{AudioTrak,Prodigy 7.1}," \
>                                         "{AudioTrak,Prodigy 7.1 LT},"\
>                                         "{AudioTrak,Prodigy 7.1 XT},"

This is a different thing. This is a long string, not a list of elements.
IMO, this one shouldn't have given a warning regardless of whether or not
the original case is valid.

Josef 'Jeff' Sipek.

-- 
If I have trouble installing Linux, something is wrong. Very wrong.
		- Linus Torvalds
