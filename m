Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbYGDBFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbYGDBFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYGDBF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:05:28 -0400
Received: from mfo30.po.2iij.net ([210.128.50.51]:8771 "EHLO mfo30.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbYGDBF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:05:27 -0400
X-Greylist: delayed 2264 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 21:05:27 EDT
Message-Id: <200807040027.m640RQSx006004@po-mbox300.hop.2iij.net>
Date: Fri, 4 Jul 2008 09:28:42 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: yoichi_yuasa@tripeaks.co.jp, "Christoph Lameter" <cl@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: slub: Do not use 192 byte sized cache if minimum alignment is
 128 byte
In-Reply-To: <84144f020807030837k213e1880vf2d01bcf77e6886c@mail.gmail.com>
References: <486CDEC2.5030803@linux-foundation.org>
	<84144f020807030837k213e1880vf2d01bcf77e6886c@mail.gmail.com>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 18:37:52 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Thu, Jul 3, 2008 at 5:14 PM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
> > The 192 byte cache is not necessary if we have a basic alignment of 128
> > byte. If it would be used then the 192 would be aligned to the next 128 byte
> > boundary which would result in another 256 byte cache. Two 256 kmalloc caches
> > cause sysfs to complain about a duplicate entry.
> >
> > MIPS needs 128 byte aligned kmalloc caches and spits out warnings on boot without
> > this patch.
> >
> > Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> Looks good to me. Yoichi, did you have the chance to test this?

I've already done.
It has no problem.

Yoichi
