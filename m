Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbYBBJWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbYBBJWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbYBBJV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:21:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48762 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYBBJV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:21:57 -0500
Date: Sat, 2 Feb 2008 10:21:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 4 of 7] x86: move pte functions into common
	asm/pgalloc.h
Message-ID: <20080202092138.GB12044@elte.hu>
References: <patchbomb.1201943112@localhost> <59bc53e1690feb091fa3.1201943116@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59bc53e1690feb091fa3.1201943116@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i've applied your series.

Small nit, please use consistent style when adding new comments:

> +/* Should really implement gc for free page table pages. This could be
> +   done with a reference count in struct page. */

i've changed that to:

 /*
  * Should really implement gc for free page table pages. This could be
  * done with a reference count in struct page.
  */

	Ingo
