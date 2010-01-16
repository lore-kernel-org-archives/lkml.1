Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999Ab0APWyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab0APWyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:54:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839Ab0APWx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:53:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:39626 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0APWx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:53:58 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 2/4] fanotify: Add pids to events
Date: Sat, 16 Jan 2010 23:53:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Matthew Helsley <matt.helsley@gmail.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org,
       containers@lists.linux-foundation.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com> <201001151612.10032.agruen@suse.de> <20100115212146.GA3714@count0.beaverton.ibm.com>
In-Reply-To: <20100115212146.GA3714@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001162353.45800.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 January 2010 10:21:46 pm Matt Helsley wrote:
> On Fri, Jan 15, 2010 at 04:12:09PM +0100, Andreas Gruenbacher wrote:
> > > 2. If the event recipient does a clone and enters a new pidns the pid
> > > number will be incorrect without any indication.
> >
> > No, if a process has a pid within the listener's namespace the listener
> > will see this pid; otherwise, the resulting pid value is 0.
> 
> So the pid reference is resolved at read(), correct? If so then that's
>  fine. (Otherwise I'd think the values could still become stale).

Yes.  Note that for non-blocking events, there is no guarantee that the 
triggering process still runs when the event is consumed though.

Andreas
