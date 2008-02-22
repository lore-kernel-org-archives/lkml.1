Return-Path: <linux-kernel-owner+w=401wt.eu-S934908AbYBVAFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934908AbYBVAFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYBVAF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:05:28 -0500
Received: from khc.piap.pl ([195.187.100.11]:56974 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYBVAF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:05:27 -0500
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
	<m3tzk1q3rt.fsf@maximus.localdomain> <47BE0C12.604@garzik.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 22 Feb 2008 01:05:26 +0100
In-Reply-To: <47BE0C12.604@garzik.org> (Jeff Garzik's message of "Thu\, 21 Feb 2008 18\:41\:06 -0500")
Message-ID: <m3k5kxq2ih.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> If a driver is full of lines of length >80, that's a problem.

I'm not sure.
We all have more than 80-chars wide displays for years, don't we? The
problem is not the number of characters but code which is too
complex and which may sometimes have too many levels of indentation.

Unfortunately expressing code complexity in terms of line lengths
doesn't seem to work at all.

The 80-chars limit harms development, it makes the code less readable,
sometimes far less readable.

I think we should increase length limit to 132 for the whole kernel
code. Obviously printk() _output_ etc. should stay at 80.
-- 
Krzysztof Halasa
