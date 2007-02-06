Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbXBFVir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbXBFVir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbXBFVir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:38:47 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:38376 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298AbXBFViq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:38:46 -0500
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Morton <akpm@linux-foundation.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070206143231.GD18392@khazad-dum.debian.net>
References: <20070202235132.EDBDF1C448@hermes.mvista.com>
	 <20070202161611.cf8b4328.akpm@linux-foundation.org>
	 <20070203003536.GA619@khazad-dum.debian.net>
	 <1170710913.6105.39.camel@nigel.suspend2.net>
	 <20070206143231.GD18392@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 08:38:44 +1100
Message-Id: <1170797924.14398.19.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2007-02-06 at 12:32 -0200, Henrique de Moraes Holschuh wrote:
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

Ok, as far as usage scenario goes, that's fair enough. But as to the
solution, I wonder though whether it's making life more complicated than
it needs to be. After all, we should also be able to cope okay with
having the power suddenly go out. If we can cope with that, cleaning
filesystems prior to suspending should be a non-issue.

Likewise with changes in hardware. Once hotplugging support is mature,
suspending, switching around hardware and resuming should just result in
hot[un]plug events.

Regards,

Nigel

