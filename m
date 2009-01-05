Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZAEFkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZAEFkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 00:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbZAEFkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 00:40:31 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:38743 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZAEFkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 00:40:31 -0500
Date: Mon, 5 Jan 2009 06:42:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>, the arch/x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
Message-ID: <20090105054206.GA14687@uranus.ravnborg.org>
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <20090105030348.GA13303@uranus.ravnborg.org> <49619601.9010900@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49619601.9010900@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 09:09:21PM -0800, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > On Sun, Jan 04, 2009 at 03:58:23PM -0800, H. Peter Anvin wrote:
> >> I have pulled the x86 parts of the bzip2/lzma patchset into
> >> tip:x86/setup-lzma.  I would appreciate it if you could look at it and
> >> make sure it looks sane.  I have not added the ARM portions (patch 4),
> >> since those should go via the ARM tree, nor the capstone patch 5, which
> >> can only be added after the old code is removed from *all* remaining
> >> architectures.
> >>
> >> Ingo: this *will* break your randconfig testing if you have machines
> >> where the lzma(1) utility isn't installed!
> >>
> >> The shortlog looks like:
> >>
> >> Alain Knaff (3):
> >>       bzip2/lzma: library support for gzip, bzip2 and lzma decompression
> >>       bzip2/lzma: config and initramfs support for bzip2/lzma 	decompression
> >>       bzip2/lzma: x86 kernel compression support
> >>
> >> H. Peter Anvin (3):
> >>       bzip2/lzma: use a table to search for initramfs compression formats
> >>       bzip2/lzma: handle failures from bzip2 and lzma correctly
> >>       bzip2/lzma: make config machinery an arch configurable
> > 
> > Can you post this last patch.
> > 
> > Thanks,
> > 	Sam
> 
> Here it is.

Looks good.
You can add a:
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

if you like.

	Sam
