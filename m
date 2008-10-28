Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYJ1Vzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYJ1Vzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYJ1Vzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:55:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYJ1Vzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:55:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
Date: Tue, 28 Oct 2008 23:00:30 +0100
User-Agent: KMail/1.9.9
Cc: ncunningham@crca.org.au, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <1224886068.6478.21.camel@nigel-laptop> <1225229399.9661.13.camel@nigel-laptop> <E1KuwTn-0006EQ-8J@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KuwTn-0006EQ-8J@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810282300.31164.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 of October 2008, Miklos Szeredi wrote:
> On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > > However it does not fix the freezing of tasks which are waiting for
> > > VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> > > This is the tricky part...
> > 
> > Convert them all to wait_event_freezeable.
> 
> You mean convert mutexes to event queues?  Not a very good idea.
> 
> I fear we are going down the same path as the last time.  I still
> don't think rewriting the VFS is the right solution to the freezing
> problem.  But hey, if you want, sumbit a patch or an RFD and lets see
> what others think.

So, what solution would you prefer?

Rafael
