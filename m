Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbYBTVAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbYBTVAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934687AbYBTU7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:59:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934651AbYBTU7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:59:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: Re: [Bug 10030] Suspend doesn't work when SD card is inserted
Date: Wed, 20 Feb 2008 21:58:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <20080220183041.46c16ef0@mjolnir.drzeus.cx> <Pine.LNX.4.44L0.0802201418520.7056-100000@iolanthe.rowland.org> <20080220215127.58b8ec70@mjolnir.drzeus.cx>
In-Reply-To: <20080220215127.58b8ec70@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802202158.08020.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 20 of February 2008, Pierre Ossman wrote:
> On Wed, 20 Feb 2008 14:26:16 -0500 (EST)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > 
> > Do I understand this correctly?  You've got special handling for the 
> > case where a bus handler doesn't have a resume routine, but no special 
> > handling for the case where it doesn't have a suspend routine?
> 
> Hmm... There should be checks for both, but the code seems to suggest otherwise.
> 
> > Why bother to remove the device if neither routine exists (there won't be 
> > any need to revive it since the bus never got suspended)?
> 
> The bus always gets suspended. The checks are to determine if state is saved or not. If it isn't, then a suspend/resume is treated as a removal/insertion.
> 
> > And why not simply fail the suspend if the resume routine doesn't exist
> > and the suspend routine does?  Maybe with an error message in the
> > system log.
> 
> For the asymmetric case, I guess that would do. But I still want to remove devices when the bus handler has no suspend handling.

I think I know how to handle that, but there's a more urgent issue I need to
fix first.  Stay tuned. :-)

Thanks,
Rafael
