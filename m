Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYIEQGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYIEQGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYIEQGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:06:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:55159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbYIEQGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:06:00 -0400
Date: Fri, 5 Sep 2008 09:05:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: pageexec@freemail.hu
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de, hpa@zytor.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905090559.7cbc74f3@infradead.org>
In-Reply-To: <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>
References: <20080903195122.73905236@infradead.org>
	<873akgw251.fsf@basil.nowhere.org>
	<20080904054444.79e71974@infradead.org>
	<48C0FF43.30940.2C3EFC0@pageexec.freemail.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2008 11:43:31 +0200
pageexec@freemail.hu wrote:

> consider how your whole patch is based on one big self-contradiction.
> you already assume that the attacker *can* modify arbitrary kernel
> memory (even the otherwise *read-only* syscall table at that), but at
> the very same time you're saying he *can't* use the same powers to
> patch out your 'protection' or do many other things to evade it. as
> it is, it's cargo cult security at its best, reminding one on the
> Vista kernel's similar 'protection' mechanism for the service
> descriptor tables...


so I'm not going to say that the patch is important or good;
it's the result of ben mentioning the idea on irc and me thinking "sure
lets see what it would take and cost".
Nothing more than that


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
