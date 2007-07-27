Return-Path: <linux-kernel-owner+w=401wt.eu-S938359AbXG0XfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938359AbXG0XfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935387AbXG0XfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:35:08 -0400
Received: from mailhost.terra.es ([213.4.149.12]:12073 "EHLO
	csmtpout1.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758658AbXG0XfH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:35:07 -0400
Date: Sat, 28 Jul 2007 01:34:24 +0200 (added by postmaster@terra.es)
From: grundig <grundig@teleline.es>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Indan Zupancic <indan@nul.nu>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources
 (was: updatedb)
Message-Id: <20070728013251.7c110223.grundig@teleline.es>
In-Reply-To: <1185573974.2711.8.camel@laptopd505.fenrus.org>
References: <200707272243.02336.a1426z@gawab.com>
	<1185568498.2711.5.camel@laptopd505.fenrus.org>
	<52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
	<1185573974.2711.8.camel@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 27 Jul 2007 15:06:14 -0700, Arjan van de Ven <arjan@infradead.org> escribió:

> how do you know there will be other activity? You start the IO and that
> basically blacks out the disk for 5 to 10 ms. If the "real" IO gets
> submitted in that time you add latency. You cannot predict that IO
> happening or not happening.

If there hasn't be much IO for some time, it looks quite reasonable to expect
that there won't be more in the near future. As most of heuristics can fail, but
then this is a feature mostly for desktops, not servers.

There's an old saying that says something like "an open source project starts
dying when new people can't participate in the project no matter how hard
they try". It's hard to understand why there's so many people opposing to
this when other more controversial features are merged much faster, (like, fe. 
the UIO driver framework). 
