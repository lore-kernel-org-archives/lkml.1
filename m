Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYFIT4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYFIT4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYFIT4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:56:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:36709 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYFIT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:56:38 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
Date: Mon, 9 Jun 2008 21:56:54 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>, gregkh@suse.de,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806091142390.2943-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806092156.55883.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 09 Juni 2008 17:44:21 schrieb Alan Stern:
> > You might argue that you deserve what you get when you hibernate
> > while printing, but then it makes no sense to implement it anyhow,
> > disconnection and reconnection work just as well and are cleaner.
> > The same is true for many devices.
> 
> In which case the correct approach is the second one I mentioned (which 
> you omitted in your reply): Make usbcore unbind drivers that don't 
> support reset_resume.

Good news.
Do you have such a patch? The current default is very drastic.

	Regards
		Oliver

