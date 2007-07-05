Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbXGEMoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbXGEMoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbXGEMoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:44:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755742AbXGEMoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:44:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 14:51:37 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Miklos Szeredi <miklos@szeredi.hu>,
       mjg59@srcf.ucam.org,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <E1I63Nv-0006Z9-00@dorka.pomaz.szeredi.hu> <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org> <18060.15630.812698.367707@cargo.ozlabs.ibm.com>
In-Reply-To: <18060.15630.812698.367707@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051451.38497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 02:36, Paul Mackerras wrote:
> Alan Stern writes:
> 
> > Remember what I wrote a few minutes ago about khubd and ksuspend_usbd
> > wanting to resume devices during a system suspend transition?  This is
> > exactly what happens when those threads aren't frozen.
> 
> So, I wonder why I don't see that error on my powerbook?

Because you have only one CPU running while your suspend code is being
executed?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
