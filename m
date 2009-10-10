Return-Path: <linux-kernel-owner+w=401wt.eu-S934728AbZJJAeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728AbZJJAeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934682AbZJJAeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:34:19 -0400
Received: from THUNK.ORG ([69.25.196.29]:42830 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934638AbZJJAeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:34:18 -0400
Date: Fri, 9 Oct 2009 20:33:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext4 corruptions
Message-ID: <20091010003339.GB18440@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alexey Fisher <bug-track@fisher-privat.net>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1255116014.3014.8.camel@mini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255116014.3014.8.camel@mini>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 09:20:13PM +0200, Alexey Fisher wrote:
> I have really bad ext4 corruptions, i needed to reinstall 3 of my test
> systems.
> The symptoms:
> is use karmic beta for this with ubuntu supplied kernel 2.6.31 ... after
> testing 2.6.32-rc[1-3] and booting again to 2.6.31 fsck will find some
> bad things and will try to fix it. After this action is the system
> unusable.
> 
> Do any one had same problem? The is no sans to bisect it, after some
> jumps between 2.6.31 and 2.6.32 the system will be broken.  Is it kernel
> or fsck problem?

Can you reproduce this reliably?  What sort of things did fsck report?
Was it after a suspend/resume that failed?

I'm using a Ubuntu 9.04 with a 2.6.32-rc1+ mainline kernel, and it
works fine for me.  So we really need many more details what sort of
filesystem corruption (not just "bad things"), and more details about
what you did while testing a newer kernel, and what sort of things
fsck complained about.

						- Ted
