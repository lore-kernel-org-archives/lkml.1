Return-Path: <linux-kernel-owner+w=401wt.eu-S1751549AbZHAXcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbZHAXcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 19:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZHAXcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 19:32:39 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:35103 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbZHAXcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 19:32:39 -0400
Date: Sun, 2 Aug 2009 00:33:05 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: =?iso-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange arch/mips/delay.c
Message-ID: <20090801233305.GA31392@linux-mips.org>
References: <9b06e8d20908011037m6b0f72cch154ed1e15bdc8938@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b06e8d20908011037m6b0f72cch154ed1e15bdc8938@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 01, 2009 at 07:37:18PM +0200, Loïc Grenié wrote:

>   I could not compile for mips without something similar to the
> following patch. As far as I can say __udelay and __ndelay
> are costly nops (with __ndelay not compiling at all) without
> the patch.
> 
>   At that point, it might be interesting to change
> the 0x00000005uLL by 0x00000045uLL and the >> 32
> by >> 36 (the precision is much better and the cost
> should be the same -- obviously there is a slightly higher
> risk of overlow).

Later versions of the kernel already contain a similar fix.  I've not
propagated MIPS fixes into upstream -stable but the fixes are available
in the -stable branches of the MIPS git repository at
git://git.linux-mips.org/pub/scm/linux.git, the tarballs created from
that repository available for download on {ftp,www}.linux-mips.org  or
on git.kernel.org.

  Ralf
