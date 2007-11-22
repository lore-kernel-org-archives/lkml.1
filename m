Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbXKVVP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbXKVVP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 16:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXKVVPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 16:15:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55097 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbXKVVPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 16:15:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tvrtko.ursulin@sophos.com
Subject: Re: [2.6.24-rc] pdflush stuck in D state
Date: Thu, 22 Nov 2007 22:33:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <OFACAE304F.F778F5BA-ON8025739B.005B6D78-8025739B.005B9AA8@sophos.com>
In-Reply-To: <OFACAE304F.F778F5BA-ON8025739B.005B6D78-8025739B.005B9AA8@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711222233.38149.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 22 of November 2007, tvrtko.ursulin@sophos.com wrote:
> linux-kernel-owner@vger.kernel.org wrote on 22/11/2007 16:28:22:
> 
> > linux-kernel-owner@vger.kernel.org wrote on 22/11/2007 16:34:01:
> > 
> > > On Thursday, 22 of November 2007, Tvrtko A. Ursulin wrote:
> > > > 
> > > > Hi all,
> > > > 
> > > > So as the subject says - pdflush is stuck i D state which means 
> > > constant load 
> > > > average of at least one:
> > > > 
> > > > root       151  0.0  0.0      0     0 ?        D    Nov20   0:33 
> > [pdflush]
> > > 
> > > Hm, this is supposed to be fixed.  Please see:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9323
> > 
> > Doesn't look like the same bug to me - I have only ever seen pdflush get 
> 
> > stuck in D, not random processes.
> > 
> > Also, I can confirm that -rc3 I am running contains the patch referenced 
> 
> > in your bugzilla link above.

OK, so I'm adding this to the list of known regreesions.

Thanks,
Rafael
