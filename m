Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbZBPRb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbZBPRb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZBPRbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:31:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:57142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763AbZBPRbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:31:19 -0500
Date: Mon, 16 Feb 2009 09:31:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090216093108.078aac35@infradead.org>
In-Reply-To: <200902161748.09208.oliver@neukum.org>
References: <200902160010.16955.rjw@sisk.pl>
	<200902160806.17901.oliver@neukum.org>
	<20090216074048.6d70f17c@infradead.org>
	<200902161748.09208.oliver@neukum.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 17:48:06 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> > Userspace should just be the part that says "I'm interested in link
> > notifications". The driver then just goes to the lowest power state
> > for its device that still gives those notifications.
> 
> Should there be a channel through which drivers can tell user space
> what the consequences in terms of reaching a sleep state are if a
> service is requested?

Personally, I don't think so.
Think about it: what would userspace do?
Not ask for the functionality if it means no sleep state?
Maybe it should just never ask for it then as a required functionality!



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
