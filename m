Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXHUBZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXHUBZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 21:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXHUBZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 21:25:06 -0400
Received: from ns.suse.de ([195.135.220.2]:39364 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbXHUBZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 21:25:05 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
References: <20070812163225.GA11996@elte.hu>
	<200708141037.48001.borntraeger@de.ibm.com>
	<20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost>
	<20070820180810.GA25160@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Aug 2007 04:18:57 +0200
In-Reply-To: <20070820180810.GA25160@elte.hu>
Message-ID: <p73lkc5zl2m.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

You should just be using idle notifiers instead instead of adding more
and more custom hooks (like NOHZ has already) x86-64 still has them
and there is a old patch around to add them to i386.

-Andi
