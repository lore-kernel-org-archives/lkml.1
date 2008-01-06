Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYAFDa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYAFDa3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYAFDaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:30:15 -0500
Received: from mail.suse.de ([195.135.220.2]:34595 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbYAFDaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:30:13 -0500
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Top 10 kernel oopses for the week ending January 5th, 2008
From: Andi Kleen <andi@firstfloor.org>
References: <477FF149.4070609@linux.intel.com>
Date: Sun, 06 Jan 2008 04:30:11 +0100
In-Reply-To: <477FF149.4070609@linux.intel.com> (Arjan van de Ven's message of "Sat\, 05 Jan 2008 13\:06\:17 -0800")
Message-ID: <p733atbr5q4.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@linux.intel.com> writes:
>
> Rank 4: remove_proc_entry
> 	Was also ranked 4th last week
> 	Only in tainted oopses
> 	Reported 3 times (12 total reports)
> 	More info: http://www.kerneloops.org/search.php?search=remove_proc_entry

Likely a broken module_exit() function that corrupts the list. To track
these down it might be useful to keep a list of recently unloaded modules
and dump these too in the oops module list with a special flag.

-Andi
