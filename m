Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYHFT4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYHFT4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYHFT40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:56:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:33130 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbYHFT4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:56:25 -0400
Date: Wed, 6 Aug 2008 12:56:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Simon Arlott <simon@fire.lp0.eu>, Rene Herman <rene.herman@keyaccess.nl>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
Message-ID: <20080806125612.6bf9eb40@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061543340.2138-100000@iolanthe.rowland.org>
References: <4899F96D.9060809@simon.arlott.org.uk>
	<Pine.LNX.4.44L0.0808061543340.2138-100000@iolanthe.rowland.org>
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

On Wed, 6 Aug 2008 15:49:27 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 6 Aug 2008, Simon Arlott wrote:
> 
> > > Wouldn't it be much simpler, and less objectionable, to do what I
> > > suggested earlier?  That is, add a 5-second delay at the start of
> > > hub_thread() in drivers/usb/core/hub.c.  No messing with
> > > Makefiles, no changes to the initcall scheduling.
> > 
> > Aside from 5 seconds being too long, and anything less being a race
> > between hub_thread() and driver initcalls, it doesn't improve
> > anything because it'll still have to wait for the devices to finish
> > initialising in userspace instead.
> 
> Why is 5 seconds too long?  Too long for what?

because I'm done booting to full UI in that time.

it's forever.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
