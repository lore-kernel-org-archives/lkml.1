Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbZBWN76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbZBWN76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 08:59:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZBWN7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 08:59:43 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:37742 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZBWN7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 08:59:43 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFD] Automatic suspend
Date: Mon, 23 Feb 2009 15:04:22 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902191356.53584.rjw@sisk.pl> <Pine.LNX.4.44L0.0902190956570.3012-100000@iolanthe.rowland.org> <20090222140311.GF1387@ucw.cz>
In-Reply-To: <20090222140311.GF1387@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231504.27879.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 22 Februar 2009 15:03:11 schrieb Pavel Machek:
> Hi!
>
> > > Again, the decision to trigger automatic suspend has to be based on
> > > some well defined criteria and the (in)activity of devices seems to be
> > > one of them.
> >
> > I don't know what criteria the system monitor would use.  It might have
> > to be platform-specific.  The Android people seem to have a pretty good
> > idea of what criteria will work for them.
> >
> > Inactivity of devices isn't always a good criterion.  There might be a
> > background task which wakes up every few seconds to do something as
> > long as the system is awake, thereby keeping some device always active.
> > The activity from this background task shouldn't prevent an auto-sleep.
>
> Then we'd need a interface to mark such background task... and what is
> reasonable use for such task, anyway? Either its job is neccessary, or
> it should not waste power.

Why? We have decided that some tasks are more important than
other tasks, to the point of starving some tasks. Posix real time
already does that.

We can just as well have a class of tasks less important than power
saving. They'd just run when power saving is not active for some other
reason. Just like other such schemes we end up with the problem
of priority inversion with locking.

	Regards
		Oliver

