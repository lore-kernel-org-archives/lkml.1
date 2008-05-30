Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbYE3GOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbYE3GOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYE3GOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:14:16 -0400
Received: from saeurebad.de ([85.214.36.134]:45980 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYE3GOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:14:15 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [patch 06/11] showmem: Only walk spanned pages.
References: <20080529125501.196123527@de.ibm.com>
	<20080529125729.607377419@de.ibm.com> <8763sxowli.fsf@saeurebad.de>
	<20080530055049.GA6475@osiris.boeblingen.de.ibm.com>
Date: Fri, 30 May 2008 08:13:41 +0200
In-Reply-To: <20080530055049.GA6475@osiris.boeblingen.de.ibm.com> (Heiko
	Carstens's message of "Fri, 30 May 2008 07:50:49 +0200")
Message-ID: <87abi8nwtm.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Heiko Carstens <heiko.carstens@de.ibm.com> writes:

> On Thu, May 29, 2008 at 07:20:57PM +0200, Johannes Weiner wrote:
>> >  	printk("%lu pages dirty\n", global_page_state(NR_FILE_DIRTY));
>> >  	printk("%lu pages writeback\n", global_page_state(NR_WRITEBACK));
>> >  	printk("%lu pages mapped\n", global_page_state(NR_FILE_MAPPED));
>> 
>> These are redundant, check show_free_areas().
>
> Indeed. Removed them. Thanks!
>
> Btw. what's up with your show_mem() cleanup patch series? I thought it
> would be merged before 2.6.26 and now it isn't even in -mm?

It interfered with my stupid `remove free swap space display' series
which is not yet completely in mainline (and no more in -mm).  I wanted
to wait until it trickled in but I think I will include the remaining
patches into the generic show_mem series and send them out soon,
obsoleting the old series...

Remaining unpatched show_mem()s in mainline are are um, sparc, sh, m32r,
alpha, sparc64 and xtensa.

	Hannes
