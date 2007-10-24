Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbXJXUV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbXJXUV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 16:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXJXUVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 16:21:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43316 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbXJXUVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 16:21:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Wed, 24 Oct 2007 22:38:02 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       linux-pm@lists.linux-foundation.org,
       huang ying <huang.ying.caritas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0709211540100.5816-100000@iolanthe.rowland.org> <200709221240.25614.rjw@sisk.pl> <20071011205445.GA3975@ucw.cz>
In-Reply-To: <20071011205445.GA3975@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710242238.02978.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 11 October 2007 22:54, Pavel Machek wrote:
> Hi!
> 
> > > That's certainly possible. We already pass a very small amount of data between 
> > > the boot and resuming kernels at the moment, and it's done quite simply - by 
> > > putting the variables we want to 'transfer' in a nosave page/section.
> > 
> > Well, if the boot and image kernels are different, which is now possible on
> > x86_64 with some recent patches (currently in -mm), the nosave trick won't
> > work.
> 
> I guess we should remove the nosave.... at least from x86-64. If
> someone tries to use it, he'll get a nasty surprise.

Agreed.

I'll try to prepare a patch for that when I have a bit of time.

Greetings,
Rafael
