Return-Path: <linux-kernel-owner+w=401wt.eu-S1761864AbXGDPKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761864AbXGDPKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760542AbXGDPJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:09:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49669 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760450AbXGDPJx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:09:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 17:17:04 +0200
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <E1I666o-0006wu-00@dorka.pomaz.szeredi.hu> <200707041703.21808.oliver@neukum.org>
In-Reply-To: <200707041703.21808.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707041717.05149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 17:03, Oliver Neukum wrote:
> Am Mittwoch, 4. Juli 2007 schrieb Miklos Szeredi:
> > > > And we won't know if drivers are OK until we remove the freezer,
> > > > catch-22.
> > > 
> > > I disagree.  We can learn that by auditing the drivers.
> > 
> > In theory, yes.  But it scales far worse than letting everyone
> > experiment/report/fix problems as they crop up.
> 
> You will open many but small races. This would be very painfull
> to debug.

Agreed.

They will not trigger 100% of the time, but sporadically and generally at
random.

At least the freezer problems are reproducible. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
