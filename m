Return-Path: <linux-kernel-owner+w=401wt.eu-S933173AbXBFSIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbXBFSIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933187AbXBFSIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:08:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44342 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173AbXBFSIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:08:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
Date: Tue, 6 Feb 2007 19:07:39 +0100
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <1170710913.6105.39.camel@nigel.suspend2.net> <20070206143231.GD18392@khazad-dum.debian.net>
In-Reply-To: <20070206143231.GD18392@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061907.40920.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 6 February 2007 15:32, Henrique de Moraes Holschuh wrote:
> On Tue, 06 Feb 2007, Nigel Cunningham wrote:
> > Why do you think remounting filesystems is necessary? Are you getting
> > problems with some particular filesystem?
> 
> No.  But anything in a removable device neets to be either remounted
> read-only or unmounted if that is at all possible, because the user could
> unplug it.  It is of course, sync'd anyway, so if the remount/umount fails,
> no corruption should happen...  but the fs will be dirty, etc.
> 
> It can get very ugly when you factor in docks and removable bays. It's not
> just USB/firewire mass-storage devices and memory cards.  And there is the
> patological cases where the user suspends with the device in one port, and
> resumes with the device in another port.
> 
> I feel userspace *can* do all that needs to be done, but we are (currently)
> very bad at it.

Agreed, but still I think that we should try to solve these problems in user
space and only _after_ it turns out to be impossible or too hard to do we can
start to implement such things on the kernel side.

Greetings,
Rafael
