Return-Path: <linux-kernel-owner+w=401wt.eu-S1760898AbXH2XQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760898AbXH2XQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbXH2XQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:16:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655AbXH2XQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:16:03 -0400
Date: Wed, 29 Aug 2007 16:15:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: jakub@redhat.com, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1 - vdso and gettimeofday issues with glibc
Message-Id: <20070829161545.9fde1a5c.akpm@linux-foundation.org>
In-Reply-To: <3909.1188409058@turing-police.cc.vt.edu>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23252.1188396273@turing-police.cc.vt.edu>
	<3909.1188409058@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 13:37:38 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 29 Aug 2007 10:04:33 EDT, Valdis.Kletnieks@vt.edu said:
> 
> (Fixing the Subject: and updating the info)
> 
> > On Wed, 22 Aug 2007 02:06:48 PDT, Andrew Morton said:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> > The issue:  vdso and gettimeofday seem to be having a quarrel.
> 
> This is also open as a Fedora bug:
> https://bugzilla.redhat.com/show_bug.cgi?id=262481
> 

So it's an interaction between the x86_64 vdso patches in Andi's tree and 
newer glibc, and we don't know which one is getting it wrong yet?

If I ever get another -mm out the door (have been without electricity for
several days) I'll drop the vdso changes until this is sorted out.
