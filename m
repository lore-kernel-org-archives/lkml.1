Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZFCThO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZFCThO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZFCThD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:37:03 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:36603 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZFCThC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:37:02 -0400
Date: Wed, 3 Jun 2009 21:39:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC: Style] Kernel coding style for Extended Attributes.
Message-ID: <20090603193918.GF3100@uranus.ravnborg.org>
References: <200906031037.50803.lkml@morethan.org> <alpine.LFD.2.01.0906030843340.4880@localhost.localdomain> <200906031211.49890.lkml@morethan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906031211.49890.lkml@morethan.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 12:11:47PM -0500, Michael S. Zick wrote:
> On Wed June 3 2009, Linus Torvalds wrote:
> > 
> > On Wed, 3 Jun 2009, Michael S. Zick wrote:
> > > 
> > > Is there a recommended style for the kernel source?
> > 
> > I think the recommended style is:
> > 
> >   "Hide them behind a macro so that they never show up in the source".
> >
> 
> That seems to be the general consensus in (/by) practice.

Use __section() to define a section.
See init.h for usage and compiler.h for definition.

	Sam
