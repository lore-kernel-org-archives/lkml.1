Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbXHUKHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbXHUKHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbXHUKHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:07:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48298 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbXHUKHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:07:20 -0400
Date: Tue, 21 Aug 2007 12:07:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821100717.GA692@one.firstfloor.org>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost> <20070820180810.GA25160@elte.hu> <p73lkc5zl2m.fsf@bingen.suse.de> <20070821070922.GA16695@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821070922.GA16695@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 09:09:22AM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > You should just be using idle notifiers instead instead of adding more 
> > and more custom hooks (like NOHZ has already) x86-64 still has them 
> > and there is a old patch around to add them to i386.
> 
> these are specially placed callbacks that we want to call from certain 
> ACPI codepaths but not from all of them.

Because you believe TSC only stops in C2 and C3? That's not correct on
all systems.

-Andi
