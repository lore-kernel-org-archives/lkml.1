Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbZATNDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbZATNDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbZATNDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:03:30 -0500
Received: from thunk.org ([69.25.196.29]:57802 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbZATND2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:03:28 -0500
Date: Tue, 20 Jan 2009 08:03:22 -0500
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arthur Jones <ajones@riverbed.com>, C Sights <csights@fastmail.fm>,
       Eric Sandeen <sandeen@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #12224] journal activity on inactive partition causes
	inactive harddrive spinup
Message-ID: <20090120130322.GB10037@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arthur Jones <ajones@riverbed.com>, C Sights <csights@fastmail.fm>,
	Eric Sandeen <sandeen@redhat.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.jfD.SKRdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX2gZ6Cy9nC.A.jfD.SKRdJB@chimera>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:45:38PM +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12224
> Subject		: journal activity on inactive partition causes inactive harddrive spinup
> Submitter	: C Sights <csights@fastmail.fm>
> Date		: 2008-12-14 11:39 (37 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c87591b719737b4e91eb1a9fa8fd55a4ff1886d6
> Handled-By	: Eric Sandeen <sandeen@redhat.com>
> 

Yes, this should still be listed.  We have a proposed patch that
should fix this, but it still needs to be finalized and tested.

              	   	     	      - Ted
