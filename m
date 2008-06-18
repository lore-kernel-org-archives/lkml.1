Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYFRSj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYFRSj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbYFRSjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:39:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56297 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbYFRSjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:39:19 -0400
Date: Wed, 18 Jun 2008 15:38:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Request for discussion on when to merge
 drivers
Message-ID: <20080618153855.4d069bb1@gaivota>
In-Reply-To: <1213802866.3515.24.camel@localhost.localdomain>
References: <1213802866.3515.24.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2008 10:27:46 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> I think the Kernel Summit would be a good place to have a discussion of
> what the criteria are for merging a driver (even if, in the end, it's at
> the discretion of the subsystem maintainers).

I agree.

> So perhaps in addition we should be
> encouraging maintainers to run staging branches under similar rules in
> the staging tree, but allowing inclusion into linux-next?

This seems a good idea for drivers.

One potencial issue that we may discuss is some sort of policy on how to deal
with drivers at the "generic" staging tree versus a subsystem maintainer
staging tree. I can foresee a few troubles if a maintainer have such tree, like:

	- After the fixes at -staging, the patch may be kept for a while at
maintainer's staging tree. So, the workflow will be longer than having just one tree;

	- Two different patches for the same device can be sent to the
"generic" staging and to the maintainer's staging tree. So, a conflict will
rise (hopefully detected at linux-next, but may require additional checks for
conflicts with PCI/USB ID's);

On the other hand, without the maintainer's staging tree, this would mean that
the maintainer would have to send their cooking drivers to the generic tree,
with doesn't seem to be very productive.

A possible solution would be if each maintainer with such staging tree would
keep the wiki at linux driver project updated, but this adds some additional
tasks to the maintainer's arms.

Cheers,
Mauro
