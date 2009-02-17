Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZBQOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZBQOza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZBQOzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:55:21 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:34686 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZBQOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:55:21 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFD] Automatic suspend
Date: Tue, 17 Feb 2009 15:56:58 +0100
User-Agent: KMail/1.9.10
Cc: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>, Len Brown <lenb@kernel.org>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <20090217142001.GB12378@bulgaria.corp.google.com> <20090217142453.GA25530@srcf.ucam.org>
In-Reply-To: <20090217142453.GA25530@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171557.02149.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Tuesday 17 February 2009 15:24:53 schrieb Matthew Garrett:
> On Tue, Feb 17, 2009 at 06:20:01AM -0800, Brian Swetland wrote:
> 
> > Of course that still doesn't address userspace.  Aggressively going to
> > suspend lets us compensate for userspace programs that do somewhat silly
> > things (I agree that it would be best if they didn't but they do and
> > getting *everyone* to write their userspace code to avoid spinning or
> > avoid waking up on short-duration timers to poll is a losing battle).
> 
> Like Pavel pointed out, you could (in principle) handle this by sending 
> a SIGSTOP to everything. The obvious problem with doing so is that this 
> wouldn't result in the processes letting go of the devices, so you 
> wouldn't neccessarily actually get to enter the runtime idle state as a 
> result. Hmm. I'll think about this.

They don't let go of the devices if you suspend either. If you want that
you need active cooperation from user space. In fact if you suspend you
give drivers the guarantee of not getting any output without prior
notification, making their lives easier.

	Regards
		Oliver


