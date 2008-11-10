Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYKJMx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYKJMx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYKJMxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:53:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbYKJMxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:53:48 -0500
Date: Mon, 10 Nov 2008 13:53:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081110125335.GB28643@elte.hu>
References: <20081109140726.GB1786@ucw.cz> <20081110075216.GD2093@elte.hu> <20081110075529.GD707@atrey.karlin.mff.cuni.cz> <20081110080436.GF2093@elte.hu> <20081110082836.GB1969@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110082836.GB1969@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0022]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> > In any case, could you send the .config that fails please, so that 
> > this is documented better?
> 
> Attached... but exact config does not seem to matter.

there are the physical memory enumeration model options:

 # CONFIG_FLATMEM_MANUAL is not set
 # CONFIG_DISCONTIGMEM_MANUAL is not set
 CONFIG_SPARSEMEM_MANUAL=y
 CONFIG_SPARSEMEM=y
 CONFIG_NEED_MULTIPLE_NODES=y
 CONFIG_HAVE_MEMORY_PRESENT=y
 CONFIG_SPARSEMEM_STATIC=y

i can only suggest some stupid tweaking of the above options - for 
example, does the bug scenario change in any way if you switch it over 
to CONFIG_DISCONTIGMEM=y ?

	Ingo
