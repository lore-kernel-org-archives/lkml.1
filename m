Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbXCUGJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbXCUGJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXCUGJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:09:53 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50003 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbXCUGJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:09:52 -0400
Date: Tue, 20 Mar 2007 22:08:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>,
       virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
Message-Id: <20070320220800.76baff30.akpm@linux-foundation.org>
In-Reply-To: <20070320202352.GF4286@bingen.suse.de>
References: <20070319.204712.118947830.davem@davemloft.net>
	<m13b40wnrb.fsf@ebiederm.dsl.xmission.com>
	<200703201428.50564.ak@suse.de>
	<m1ircvswzz.fsf@ebiederm.dsl.xmission.com>
	<20070320174159.GA4286@bingen.suse.de>
	<Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org>
	<20070320180359.GB4286@bingen.suse.de>
	<Pine.LNX.4.64.0703201022040.6730@woody.linux-foundation.org>
	<20070320192118.GD4286@bingen.suse.de>
	<Pine.LNX.4.64.0703201145570.6730@woody.linux-foundation.org>
	<20070320202352.GF4286@bingen.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 21:23:52 +0100 Andi Kleen <ak@suse.de> wrote:

> Well it causes additional problems. We had some cases where it was really
> hard to distingush garbage and the true call chain.

yes, for some reason the naive backtraces seem to have got messier and messier over
the years and some of them are really quite hard to piece together nowadays.

An accurate backtrace would have some value, if we can get it bullet-proof.

The fault-injection driver wants it too.  And lockdep, I guess.
