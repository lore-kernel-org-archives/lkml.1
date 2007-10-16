Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXJPK0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXJPK0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 06:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759225AbXJPK0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 06:26:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56997 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760077AbXJPK0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 06:26:20 -0400
Date: Tue, 16 Oct 2007 11:28:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Message-ID: <20071016112859.1b0fba0e@the-village.bc.nu>
In-Reply-To: <200710160138.57893.rob@landley.net>
References: <200710112011.22000.rob@landley.net>
	<200710161659.28826.nickpiggin@yahoo.com.au>
	<m1lka3ishi.fsf@ebiederm.dsl.xmission.com>
	<200710160138.57893.rob@landley.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm sure somebody will eventually write an OLS paper or something on the 
> advisability of making swapping decisions with 4k granularity when disks 
> really want bigger I/O transactions. 

Funnily enough someone thought of that many years ago. They even added
and documented it, then they made it adjustable.

See the vm section of Documentation/filesystems/proc.txt

Alan
