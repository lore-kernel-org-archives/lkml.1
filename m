Return-Path: <linux-kernel-owner+w=401wt.eu-S1761916AbZCXUO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761916AbZCXUO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbZCXUOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:14:49 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:60313 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbZCXUOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:14:48 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	<20090324125510.GA9434@duck.suse.cz>
	<20090324132637.GA14607@duck.suse.cz>
	<200903250130.02485.nickpiggin@yahoo.com.au>
	<20090324144709.GF23439@duck.suse.cz>
	<1237906563.24918.184.camel@twins>
	<20090324152959.GG23439@duck.suse.cz>
Date: Wed, 25 Mar 2009 05:14:34 +0900
In-Reply-To: <20090324152959.GG23439@duck.suse.cz> (Jan Kara's message of
	"Tue, 24 Mar 2009 16:29:59 +0100")
Message-ID: <873ad2znit.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   BTW: Note that there's a plenty of filesystems that don't implement
> mkwrite() (e.g. ext2, UDF, VFAT...) and thus have the same problem with
> ENOSPC. So I'd not speak too much about consistency ;).

FWIW, fatfs doesn't allow sparse file (mmap the non-allocated region),
so I guess there is no problem.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
