Return-Path: <linux-kernel-owner+w=401wt.eu-S934391AbXHGRhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391AbXHGRhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 13:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbXHGRhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 13:37:45 -0400
Received: from mail.acc.umu.se ([130.239.18.156]:34903 "EHLO mail.acc.umu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757928AbXHGRho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 13:37:44 -0400
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 13:37:44 EDT
Date: Tue, 7 Aug 2007 19:05:14 +0200
From: David Weinehall <tao@kernel.org>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Linux 2.6.23-rc2
Message-ID: <20070807170513.GF20404@vasa.acc.umu.se>
Mail-Followup-To: Jeff Chua <jeff.chua.linux@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>,
	"Antonino A. Daplas" <adaplas@gmail.com>
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org> <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com> <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com> <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com> <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org> <46B4C011.8090802@zytor.com> <b6a2187b0708041937u41f3911ap3f1af6115b797d6b@mail.gmail.com> <46B53FDF.5020806@zytor.com> <b6a2187b0708050452m1b1b5c5ck163f64a26686d3cc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0708050452m1b1b5c5ck163f64a26686d3cc@mail.gmail.com>
X-Editor: Vi Improved <http://www.vim.org/>
X-Accept-Language: Swedish, English
X-GPG-Fingerprint: 7ACE 0FB0 7A74 F994 9B36  E1D1 D14E 8526 DC47 CA16
X-GPG-Key: http://www.acc.umu.se/~tao/files/pub_dc47ca16.gpg.asc
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 07:52:07PM +0800, Jeff Chua wrote:
> On 8/5/07, H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > Okay, since you're using VGA console this means suspend-to-ram isn't
> > restoring the mode.
> > Does it matter if you suspend from inside X or not?
> 
> Just tested it. It doesn't matter... text console still messed up. X
> is ok after resume.

Try adding acpi_sleep=s3_bios to your kernel boot options and see if it
helps.


Regards: David
-- 
 /) David Weinehall <tao@acc.umu.se> /) Northern lights wander      (\
//  Maintainer of the v2.0 kernel   //  Dance across the winter sky //
\)  http://www.acc.umu.se/~tao/    (/   Full colour fire           (/
