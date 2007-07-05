Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbXGENyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbXGENyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbXGENyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:54:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53686 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbXGENyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:54:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 16:02:17 +0200
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051523.44826.rjw@sisk.pl> <200707051528.34754.oliver@neukum.org>
In-Reply-To: <200707051528.34754.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707051602.19042.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 15:28, Oliver Neukum wrote:
> Am Donnerstag, 5. Juli 2007 schrieb Rafael J. Wysocki:
> > > It seems pretty clear cut.  Whining about how much problems this will
> > > cause won't get us nearer to a solution.
> > 
> > Yes, that's pretty clear cut, but we should start from fixing the drivers. :-)
> 
> If, at a minimum, we can determine that we can STD without a freezer.

No, we can't.

> It makes no sense to invest a lot of work to face the same problem
> again with STD.

Arguably, it does make sense, because for many platforms the hibernation
is irrelevant and we're going to separate the suspend and hibernation
frameworks anyway.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
