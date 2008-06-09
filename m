Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbYFIPMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbYFIPMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYFIPMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:12:31 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53668 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYFIPMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:12:31 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Date: Mon, 9 Jun 2008 17:12:45 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>, gregkh@suse.de,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0806091100060.2943-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806091100060.2943-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091712.46869.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 Juni 2008 17:03:10 schrieb Alan Stern:
> On Mon, 9 Jun 2008, Pavel Machek wrote:
> 
> > Besides, it seems to break suspend/resume of printers, and probably
> > all the drivers that do not have reset_resume() method. That's
> > actually a regression.
> > 
> > https://bugzilla.novell.com/show_bug.cgi?id=394820
> 
> The right way to fix this is to add reset_resume to the printer driver.  

reset_resume() is supposed to restore all state. The printer driver does
not know which state a printer is in, except for the trivial case of the
printer not being in use, as it doesn't know the meaning of the data
going to the printer.

You might argue that you deserve what you get when you hibernate
while printing, but then it makes no sense to implement it anyhow,
disconnection and reconnection work just as well and are cleaner.
The same is true for many devices.

	Regards
		Oliver
