Return-Path: <linux-kernel-owner+w=401wt.eu-S1765282AbYBTWyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765282AbYBTWyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYBTWxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:53:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365AbYBTWxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:53:51 -0500
Date: Wed, 20 Feb 2008 17:53:09 -0500
From: Rik van Riel <riel@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       roland@redhat.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - Kernel panic while bootup caused by
 signal_group_exit()
Message-ID: <20080220175309.6ce3cb31@cuia.boston.redhat.com>
In-Reply-To: <20080220200440.GA105@tv-sign.ru>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47B7B3B9.2090706@linux.vnet.ibm.com>
	<20080220143417.6e419c5e@cuia.boston.redhat.com>
	<20080220200440.GA105@tv-sign.ru>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 23:04:40 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> Yes, please look at http://marc.info/?t=120309840500006
> 
> Btw. The bug in tty_io.c _can_ explain this trace, but it would be nice
> to ensure we don't have other problems. Could you try this
> 
> 	http://marc.info/?l=linux-kernel&m=120352655031911
> 
> patch?

Fun.  With that debugging patch applied, the oops on boot no longer
happens...

No, I have no idea why...

-- 
All Rights Reversed
