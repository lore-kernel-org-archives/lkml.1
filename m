Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZAHQst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZAHQst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZAHQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:48:40 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:59449 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZAHQsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:48:40 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Date: Thu, 8 Jan 2009 17:48:57 +0100
User-Agent: KMail/1.9.10
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200901080835.39639.rjw@sisk.pl> <200901080949.34339.oliver@neukum.org> <200901081736.12926.rjw@sisk.pl>
In-Reply-To: <200901081736.12926.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901081748.58962.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 08 January 2009 17:36:12 schrieb Rafael J. Wysocki:
> > We do support remote wakeup from PS2 keyboards. So you might argue we
> > should do the same for USB HID devices.
> 
> Well, _I_ can live with a few 'echo disabled > /sys/devices/.../power/wakeup'
> lines in my init scripts, but I'm afraid we're going to get many problem
> reports related to this.  This means people will likely lose time on trying to
> debug this problem and someone will have to handle the reports.  Are you
> volunteering to do that?

You are making a very persuasive argument for reverting it.
But what about laptops that only have a USB keyboard?

> Also, it would have been nice to notify people of such a change of behavior in
> advance.

Yes, sorry.

	Regards
		Oliver


