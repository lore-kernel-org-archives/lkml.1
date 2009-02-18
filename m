Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZBRPQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZBRPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZBRPQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:16:18 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58857 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZBRPQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:16:18 -0500
Date: Wed, 18 Feb 2009 15:15:29 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090218151529.GB15195@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090217142001.GB12378@bulgaria.corp.google.com> <20090217064630.688bf639@infradead.org> <20090217145141.GA26158@srcf.ucam.org> <20090217065622.3e0a9956@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217065622.3e0a9956@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 06:56:22AM -0800, Arjan van de Ven wrote:

> so use range timers / timer slack for those apps that you do not trust.
> That is not a big deal, and solves the issue of timer wakeups...

So have userspace say something like "The screen is turned off now, 
change the timer precision on all untrusted userland to sub 10 seconds"? 
That would work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
