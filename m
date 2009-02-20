Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbZBTXqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbZBTXqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZBTXqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:46:21 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33868 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbZBTXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:46:21 -0500
Date: Fri, 20 Feb 2009 23:45:48 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090220234548.GA9297@srcf.ucam.org>
References: <200902192215.18365.rjw@sisk.pl> <200902201657.01145.rjw@sisk.pl> <200902210012.08088.oliver@neukum.org> <200902210040.50344.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902210040.50344.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 12:40:48AM +0100, Rafael J. Wysocki wrote:

> We can't do the quirks from the kernel and that's one of the reasons why I
> think user space should start automatic suspend (it can do the quirks if
> necessary).

Any sort of automatic suspend is simply impossible in a world where your 
drivers don't work properly. There's code for making intel and radeon 
handle suspend/resume themselves now, and nvidia before g80 should also 
be easy. More recent nvidia is going to be some work.

But yeah. Let's not have "Work around broken drivers" as a design goal. 
The argument against timeouts in wakelocks works just as well here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
