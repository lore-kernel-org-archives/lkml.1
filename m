Return-Path: <linux-kernel-owner+w=401wt.eu-S1762700AbYDNQ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762700AbYDNQ72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760536AbYDNQ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:59:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45227 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758427AbYDNQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:59:18 -0400
Date: Mon, 14 Apr 2008 17:54:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080414175452.27c3652d@core>
In-Reply-To: <20080414165354.GF15824@duck.suse.cz>
References: <agh4d-6yc-35@gated-at.bofh.it>
	<ah5tY-3lR-7@gated-at.bofh.it>
	<ah5DA-3X9-9@gated-at.bofh.it>
	<ah5X5-4tl-13@gated-at.bofh.it>
	<ah66A-4Nk-7@gated-at.bofh.it>
	<ah7vN-7Wz-9@gated-at.bofh.it>
	<E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org>
	<20080411135544.GG2160@csclub.uwaterloo.ca>
	<20080414162031.GD15824@duck.suse.cz>
	<20080414162202.GB7387@csclub.uwaterloo.ca>
	<20080414165354.GF15824@duck.suse.cz>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Well, but imagine you have a file /proc/my_secret_file from which you
> are able to read from position A:a and B:b but not from position
> A:b. Concievably, checks for the file position could be bypassed because of
> this race... I know this is kind of dumb example but I can imagine someone

Unlikely as the ppos passed to the driver is a private copy and the user
could equally use pread/pwrite to specify that offset.
