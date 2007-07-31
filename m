Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbXGaQt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbXGaQt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764439AbXGaQtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:49:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764034AbXGaQtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:49:18 -0400
Date: Tue, 31 Jul 2007 22:31:36 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: David Woodhouse <dwmw2@infradead.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make headers_check less chatty for success cases
In-Reply-To: <1185899409.3083.122.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.0.999.0707312220570.28746@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0707312206140.28746@enigma.security.iitk.ac.in>
 <1185899409.3083.122.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, David Woodhouse wrote:

> On Tue, 2007-07-31 at 22:10 +0530, Satyam Sharma wrote:
> > "make headers_check" is too verbose. It likes to chat even if it has
> > just _successfully_ checked a header, and not just on seeing errors.
> > What is worse, even if you touch just one little header in some corner
> > (or possibly none) and type "make" on an "already-made" tree,
> > headers_check still feels obliged to check all the headers.
> 
> Didn't Sam have a better fix for that?

None that I see in kbuild.git, at least ... Anyway, now that I've silenced
headers_check, I keep seeing:

make[2]: `scripts/unifdef' is up to date.

which is because of the:

make -f scripts/Makefile.build obj=scripts scripts/unifdef
                       (passed separately) ^^^^^^^^^^^^^^^

from the top-level Makefile (scripts/Makefile says something about it
being built only on demand ...)
