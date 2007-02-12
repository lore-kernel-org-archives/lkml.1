Return-Path: <linux-kernel-owner+w=401wt.eu-S1751012AbXBLA1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012AbXBLA1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbXBLA1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:27:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbXBLA1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:27:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: NAK new drivers without proper power management?
Date: Mon, 12 Feb 2007 01:24:50 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>,
       nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
References: <1171058269.1484.64.camel@nigel.suspend2.net> <200702120004.15529.rjw@sisk.pl> <20070212002851.3ca1b27a@localhost.localdomain>
In-Reply-To: <20070212002851.3ca1b27a@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702120124.51180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 February 2007 01:28, Alan wrote:
> > +PM support:	Since Linux is used on many portable and desktop systems, your
> > +		driver is likely to be used on such a system and therefore it
> > +		should support basic power management by implementing, if
> > +		necessary, the .suspend and .resume methods used during the
> > +		system-wide suspend and resume transitions.  You should verify
> > +		that your driver correctly handles the suspend and resume, but
> > +		if you are unable to ensure that, please at least define the
> > +		.suspend method returning the -ENOSYS ("Function not
> > +		implemented") error.  Note, however, that in such a case your
> > +		submission is likely to be suspended and only resumed when the
> > +		driver correctly handles this feature.
> 
> I'd lose the last bit. Just end it at "error.", there are going to be
> people who produce good reasons not to handle suspend/resume.

OK, I will.
