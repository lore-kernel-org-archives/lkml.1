Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZBQOZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZBQOZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZBQOZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:25:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:58846 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZBQOZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:25:09 -0500
Date: Tue, 17 Feb 2009 14:24:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Brian Swetland <swetland@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
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
Message-ID: <20090217142453.GA25530@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090217142001.GB12378@bulgaria.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217142001.GB12378@bulgaria.corp.google.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 06:20:01AM -0800, Brian Swetland wrote:

> Of course that still doesn't address userspace.  Aggressively going to
> suspend lets us compensate for userspace programs that do somewhat silly
> things (I agree that it would be best if they didn't but they do and
> getting *everyone* to write their userspace code to avoid spinning or
> avoid waking up on short-duration timers to poll is a losing battle).

Like Pavel pointed out, you could (in principle) handle this by sending 
a SIGSTOP to everything. The obvious problem with doing so is that this 
wouldn't result in the processes letting go of the devices, so you 
wouldn't neccessarily actually get to enter the runtime idle state as a 
result. Hmm. I'll think about this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
