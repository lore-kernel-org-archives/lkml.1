Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZKETbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZKETbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbZKETbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:31:48 -0500
Received: from THUNK.ORG ([69.25.196.29]:37620 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932AbZKETbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:31:48 -0500
Date: Thu, 5 Nov 2009 14:31:50 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Shawn Starr <shawn.starr@rogers.com>
Subject: Re: [Bug #14472] EXT4 corruption
Message-ID: <20091105193150.GO6510@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Lutomirski <luto@MIT.EDU>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Shawn Starr <shawn.starr@rogers.com>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <6dRYo8ss7vL.A.haF.Are5KB@chimera> <cb0375e10910291257t1f2f16ciade932bd78689ccc@mail.gmail.com> <20091029222335.GJ18464@mit.edu> <cb0375e10911031543n5cfcc090k8780449a1413b067@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0375e10911031543n5cfcc090k8780449a1413b067@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 06:43:11PM -0500, Andrew Lutomirski wrote:
> It looks like 2.6.32-rc6 is supposed to fix this bug, but it also
> looks like this patch didn't make it in.  Should I still be using this
> patch?

This patch does fix a potential problem and I am planning on pushing
it to Linus; the chances of hitting the race is quite low, though; the
revert which Eric identified is probably what was affecting most of
the people who were seeing problems with ext4 in 2.6.32-rcX.

    	       	    	   	    	      	 - Ted
