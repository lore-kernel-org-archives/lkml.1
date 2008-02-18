Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbYBRFBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbYBRFBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264AbYBRFB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:01:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45774 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYBRFB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:01:27 -0500
Date: Sun, 17 Feb 2008 21:06:03 -0800
From: Greg KH <greg@kroah.com>
To: David Newall <davidn@davidnewall.com>
Cc: Stephan Rose <stephan@eciinternational.de>,
       Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PL2303 Driver missing support for USB to Serial Cable
Message-ID: <20080218050603.GB15141@kroah.com>
References: <1203001060.8420.11.camel@software> <47B6DC7A.3040308@gmail.com> <47B6DF8C.7030106@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B6DF8C.7030106@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 11:35:16PM +1030, David Newall wrote:
> Stephan,
> 
> Jiri Slaby wrote:
> > On 02/14/2008 03:57 PM, Stephan Rose wrote:
> >> I recently purchased a USB->Com Port serial cable from Radio Shack
> >> (Model number 26-183) which did no seem to want to work. After looking
> >> into it I discovered that it is based on the Prolific chipset using the
> >> PL2303 driver.
> >
> > Well, would you mind creating, testing and posting a patch?
> 
> 
> You needn't bother.  As far as I'm concerned, what you sent is
> sufficient and, as I am currently working on the pl2303 driver, you can
> rest assured that it will be included in the patch that I send.

That might be pretty tough to do, as it's already in the 2.6.25-rc2
release :)

And please, patches need to be one-thing-per-patch.  Don't try to mix
cleanups, bug fixes, and also new devices ids all in one patch.

Stephan, thanks for the report, but someone beat you to it by a few
weeks already, the driver is updated.

thanks,

greg k-h
