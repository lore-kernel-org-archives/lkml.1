Return-Path: <linux-kernel-owner+w=401wt.eu-S1761661AbXIUSnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761661AbXIUSnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761454AbXIUSmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:42:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761243AbXIUSmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:42:50 -0400
Date: Fri, 21 Sep 2007 11:42:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andy Fleming <afleming@freescale.com>, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
Message-Id: <20070921114207.f0b54b3b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64N.0709211334420.2724@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709171750220.17606@blysk.ds.pg.gda.pl>
	<20070920165348.0b25be3d.akpm@linux-foundation.org>
	<Pine.LNX.4.64N.0709211334420.2724@blysk.ds.pg.gda.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 13:51:12 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

> On Thu, 20 Sep 2007, Andrew Morton wrote:
> 
> > You always put boring, crappy, insufficient text in the for-the-changelog
> > section and interesting, useful, sufficient text in the not-for-the-changelog
> > section.
> 
>  I'll swap the sections in the future then. ;-)  Frankly I was not sure 
> whether the changelog was happy about being fed with lengthy explanations 
> and it has not spoken out.

I think it's worth putting plenty of details in the changelog: it's compressed
on-disk and on-the-wire and is overall pretty cheap.  If people don't
actually seek the information out, it has close to zero impact on them.

But on those occasions when people _do_ seek the information out (and it
can be years later) then they want every drop of information they can get.

Numerous times I've gone back to the 2.5.x mm/ changelogs to work out
what on earth we were thinking when we did something, and it has proved
quite useful in explaining the existing code, or in suggesting possible
problems which we had forgotten about by 2007.


otoh, you can get a lot of handy info by googling for strategic parts of
the kernel code, or by googling snippets of the existing-but-short
changelog.  For example, this patch: google for "Keep track of
disable_irq_nosync() invocations" and voila.  Perhaps we don't need
changelogs at all ;)

