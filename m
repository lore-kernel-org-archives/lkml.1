Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbXHUHKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbXHUHKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759883AbXHUHJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:09:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47118 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759734AbXHUHJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:09:44 -0400
Date: Tue, 21 Aug 2007 09:09:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821070922.GA16695@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost> <20070820180810.GA25160@elte.hu> <p73lkc5zl2m.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73lkc5zl2m.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> You should just be using idle notifiers instead instead of adding more 
> and more custom hooks (like NOHZ has already) x86-64 still has them 
> and there is a old patch around to add them to i386.

these are specially placed callbacks that we want to call from certain 
ACPI codepaths but not from all of them.

	Ingo
