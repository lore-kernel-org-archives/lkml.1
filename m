Return-Path: <linux-kernel-owner+w=401wt.eu-S1760626AbZCZS4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760626AbZCZS4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 14:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbZCZS4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 14:56:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40838 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755424AbZCZS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:56:29 -0400
Date: Thu, 26 Mar 2009 18:55:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, mingo@elte.hu, tytso@mit.edu,
       jack@suse.cz, arjan@infradead.org, a.p.zijlstra@chello.nl,
       npiggin@suse.de, jens.axboe@oracle.com, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, oleg@redhat.com,
       roland@redhat.com, willy@linux.intel.com, vaurora@redhat.com
Subject: Re: [PATCH] Allow relatime to update atime once a day
Message-ID: <20090326185522.42995ca3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326173214.GA7198@srcf.ucam.org>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326140312.GB14822@elte.hu>
	<20090326073013.2fa83178.akpm@linux-foundation.org>
	<200903261632.42439.elendil@planet.nl>
	<20090326084733.156c4910.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903260912270.3032@localhost.localdomain>
	<20090326173214.GA7198@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 17:32:14 +0000
Matthew Garrett <mjg@redhat.com> wrote:

> Allow atime to be updated once per day even with relatime. This lets
> utilities like tmpreaper (which delete files based on last access time)
> continue working, making relatime a plausible default for distributions.

And while I think forcing relatime on is a really dumb dangerous idea,
providing it so you can enable it (or distro new releases can for new
installs etc) is a *very good* one
