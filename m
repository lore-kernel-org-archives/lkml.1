Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbXBWRzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbXBWRzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932488AbXBWRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:55:54 -0500
Received: from khc.piap.pl ([195.187.100.11]:54310 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXBWRzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:55:54 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3hctfqjna.fsf@maximus.localdomain>
	<20070221224027.GK22464@csclub.uwaterloo.ca>
	<200702212355.25601.s0348365@sms.ed.ac.uk>
	<m3bqjnrntu.fsf@maximus.localdomain> <45DF0C29.2080201@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 23 Feb 2007 18:55:50 +0100
In-Reply-To: <45DF0C29.2080201@xs4all.nl> (Udo van den Heuvel's message of "Fri, 23 Feb 2007 16:45:45 +0100")
Message-ID: <m3wt2869nd.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> I will try a different case with a different dual PCI riser card soon.
> This Morex riser has DN20-31 or so, so more options.
> Could this help solve my irq issue? (try 4 consecutive DNs until I have
> the right mapping?)

I don't think so. Unless you can configure INT connections on the riser
card, of course.

You need DN19 for the second slot (and perhaps 10 would work with
double INTx rotation), that's fixed in the BIOS.
-- 
Krzysztof Halasa
