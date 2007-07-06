Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbXGFG4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbXGFG4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759946AbXGFG4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:56:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56868 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbXGFG4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:56:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:04:08 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051048.46202.oliver@neukum.org> <1183675095.3388.72.camel@localhost.localdomain>
In-Reply-To: <1183675095.3388.72.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707060904.09497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6 July 2007 00:38, Benjamin Herrenschmidt wrote:
> 
> > There is that.
> > 
> > OK, bite the bullet. Tasks involved in fuse are special. Give them a flag
> > and teach the freezer to put them on ice only after all other task are
> > frozen. In a way they are kernel, there's no use denying that.
> 
> Yet another ugly hack to work around the fact that the freezer cannot
> work reliably ... yuck
> 
> Why not spend that energy fixing drivers to properly block requests
> instead ?

Because it's more difficult? :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
