Return-Path: <linux-kernel-owner+w=401wt.eu-S936589AbYEBU64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936589AbYEBU64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762115AbYEBU6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:58:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:56916 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935073AbYEBU6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:58:44 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Tim Gardner <timg@tpi.com>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 16:58:00 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: jeffschroeder@computer.org, Jan Engelhardt <jengelh@medozas.de>,
       Jeff Mahoney <jeffm@suse.com>, Tim Gardner <tim.gardner@canonical.com>,
       linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       John Johansen <jjohansen@suse.de>
References: <200804291601.32945.chris.mason@oracle.com> <200805021034.08358.chris.mason@oracle.com> <481B3C0E.502@tpi.com>
In-Reply-To: <481B3C0E.502@tpi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021658.01459.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Tim Gardner wrote:
> Chris Mason wrote:
> > On Friday 02 May 2008, Jeff Schroeder wrote:
> >
> > [ Btrfs oops with apparmor patched in ]
> >
> >> Make is not my forte, but here is a working test to see if apparmor
> >> exists in Ubuntu 8.04.
> >> Maybe have make apply a patch to the btrfs source if this test
> >> succeeds? Does this work in SUSE?
> >>
> >> http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_t
> >>est _for_btrfs.patch
> >
> > Thanks, but this uses CONFIG_SECURITY_APPARMOR which isn't enough to tell
> > if the kernel has the patch.  Lets go back to Jeff's suse patch:
> >

I ended up using the CONFIG_SECURITY_APPARMOR test because the other test 
suggested here sounded like something that might eventually not be very 
ubuntu specific (instead of the nice a plain CONFIG_SUSE_KERNEL).

Thanks to everyone for the hints, if someone could please test:

http://btrfs.wiki.kernel.org/index.php/Hot_Fixes

I'd be grateful.

-chris
