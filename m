Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXIUL5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXIUL5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbXIUL5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:57:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252AbXIUL5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:57:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 14:10:44 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, nigel@suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <200709211024.35991.nigel@nigel.suspend2.net> <20070921094908.GB20149@elf.ucw.cz>
In-Reply-To: <20070921094908.GB20149@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211410.45248.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 11:49, Pavel Machek wrote:
> Hi!
> 
> > > Seems like good enough for -mm to me.
> 
> (For the record, I do not think this is going to be
> hibernation-replacement any time soon. But it is functionality useful
> for other stuff -- dump memory and continue -- and yes it may be able
> to do hibernation in the long term.
> 
> It really comes from the other side of reliability:
> 
> * swsusp is "if your kernel is perfectly healthy, it will work"
> 
> while this, coming from kdump is
> 
> * "if your kernel is not completely trashed, it should work"
> 
> ...which is why can't use swsusp to do dump memory and continue -- you
> want to do dumps on "slightly broken" systems. And yes, as a
> sideeffect it may be able to do hibernation... why not, lets see how
> it works out).

I generally agree. :-)

Greetings,
Rafael
