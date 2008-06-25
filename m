Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbYFYJqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbYFYJqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYFYJqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:46:38 -0400
Received: from bu3sch.de ([62.75.166.246]:44454 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYFYJqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:46:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: Oops when using growisofs
Date: Wed, 25 Jun 2008 11:46:29 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de> <200806242039.18755.mb@bu3sch.de> <20080625093700.GB15865@duck.suse.cz>
In-Reply-To: <20080625093700.GB15865@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251146.30142.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 June 2008 11:37:00 Jan Kara wrote:
> > Yeah the IO error is the trigger.
> > I noticed that it had obvious troubles accessing the DVD that was in the drive.
> > It sweeped over it for several seconds, then hung the system for 2 or 3 seconds
> > and then oopsed. But after that everything continued to work as usual.
> > (Except kded of course)
>   Hmm, by "accessing" do you mean that you've mounted the burned DVD and when
> browsing it the IO error and the oops occured or that IO error happened
> when burning? It is important because in the first case i_blkbits would be
> taken from some ISOFS inode desribing some file while in the second case
> i_blkbits are from the inode of the device...


I don't know. kded, which caused the oops, is always running. It is a KDE daemon
that polls device state and so on. So yeah, it might have accessed the drive
while growisofs was writing to it.

However with "accessing" I mean the DVD drive motor was spinning up and down
and the laser lens was moving like crazy. The sound that happens, if you put
a completely scratched DVD into the drive and it is unable to make sense of it.
However, this was not scratched. It was a new DVD with one session on it that
I just burnt 5 minutes before that. So I wanted to append another session to it
and it crashed and resulted in IO errors in growisofs.

-- 
Greetings Michael.
