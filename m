Return-Path: <linux-kernel-owner+w=401wt.eu-S1762554AbXGKLNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554AbXGKLNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759057AbXGKLM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:12:57 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:39243 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbXGKLM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:12:56 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu,
       pavel@ucw.cz, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-reply-to: <200707111304.40504.rjw@sisk.pl>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <200707111227.52609.rjw@sisk.pl> <E1I8Ze4-0008OM-00@dorka.pomaz.szeredi.hu> <200707111304.40504.rjw@sisk.pl>
Message-Id: <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 13:11:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyway, to implement the kexec approach we must separate the
> hibernation from the suspend at the drivers level, which I'm still
> going to do, but I need to take part in endless discussions

Discussions are good.  We understand the problem better.  Now I still
think we don't understand every aspect completely, so continuing the
discussion makes sense.

> regarding the freezer, how it is bad and how we should drop it,
> because it breaks things (which NB is not true, because it doesn't).

This thread started out from a bug, that seemed to be caused by the
freezer (we still don't exactly know what it was caused by), and the
discussion uncovered various problems _with_ the freezer, that up to
now no other _proper_ solutions have been propsed than to remove the
freezer.

Yes, we can live with hacks, but we don't want to live with them
forever.  Even if they seem to be simpler than a big rewrite, the long
term headaches are not worth it.

Miklos
