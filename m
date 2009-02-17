Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZBQOwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZBQOwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZBQOvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:51:52 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43948 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZBQOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:51:52 -0500
Date: Tue, 17 Feb 2009 14:51:41 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
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
Message-ID: <20090217145141.GA26158@srcf.ucam.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org> <20090217142001.GB12378@bulgaria.corp.google.com> <20090217064630.688bf639@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217064630.688bf639@infradead.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 06:46:30AM -0800, Arjan van de Ven wrote:

> actually with powertop... on the open source side things are actually
> won. It took all of 6 months...
> I don't see that as a valid excuse. In fact, if this kind of solution
> makes real userspace scheduled timers to be missed then I consider it a
> serious functionality misfeature.

Remember that Android has an open marketplace designed to appeal to Java 
programmers - users are going to end up downloading code from there and 
then blaming the platform if their battery life heads towards zero. I 
think "We can't trust our userland not to be dumb" is a valid concern.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
