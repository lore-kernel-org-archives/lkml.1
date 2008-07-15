Return-Path: <linux-kernel-owner+w=401wt.eu-S1761931AbYGOReZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761931AbYGOReZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbYGOReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:34:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:48400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbYGOReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:34:17 -0400
Date: Tue, 15 Jul 2008 10:33:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Frans Pop <elendil@planet.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jeff@garzik.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from
 in-kernel, use it in more drivers.
Message-ID: <20080715103352.4a47419e@infradead.org>
In-Reply-To: <200807151836.57983.elendil@planet.nl>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	<200807151757.10626.elendil@planet.nl>
	<20080715090441.478c2287@infradead.org>
	<200807151836.57983.elendil@planet.nl>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 18:36:56 +0200
Frans Pop <elendil@planet.nl> wrote:

> On Tuesday 15 July 2008, you wrote:
> > > You release 2.6.27-rc2 and I build it. Ouch! It fails to install,
> > > at least if I want to install it _alongside_ 2.6.27-rc1 or other
> > > kernels (which I do!). Why does it fail? Because dpkg's package
> > > management does not allow one package to overwrite files already
> > > "owned" by another package.
> >
> > question: how do you deal with this with the dozens of drivers that
> > use request_firmware() even before yesterday ?
> > the answer is critical in how to deal with this "new" situation as
> > well ;-)
> 
> For Debian packages that's in the part of the mail you snipped.
> 
> The simple answer for my current use of dep-pkg is: I don't _have_
> any hardware that requires firmware that's split out with current
> kernels.

... and do you have any with current -git ?


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
