Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYLFR0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYLFR0l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 12:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYLFR0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 12:26:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60170 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbYLFR0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 12:26:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] PCI: Suspend and resume PCI Express ports with interrupts disabled
Date: Sat, 6 Dec 2008 18:25:59 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061508.00277.rjw@sisk.pl> <alpine.LFD.2.00.0812060914100.3425@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812060914100.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061825.59914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of December 2008, Linus Torvalds wrote:
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > I don't see why the suspend and resume of PCI Express ports should be
> > handled with interrupts enabled and it may even lead to problems in
> > some situations.
> 
> Absolutely. A PCI Express port is really just a PCI bridge, with some odd 
> rules. We need to enable them early, exacly like regular PCI bridges, or 
> we cannot walk the PCI bus hierarchy correctly.
> 
> Anyway, ack, ack, ack for the whole series.

Thanks! :-)

I think it should go through Jesse?

Rafael
