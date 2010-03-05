Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0CEWCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:02:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54059 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab0CEWCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:02:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: Problems with remote-wakeup settings
Date: Fri, 5 Mar 2010 23:04:49 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       linux-input@vger.kernel.org, linux-hotplug@vger.kernel.org,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1003051546370.1384-100000@iolanthe.rowland.org> <201003052208.09486.oliver@neukum.org>
In-Reply-To: <201003052208.09486.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003052304.49261.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 March 2010, Oliver Neukum wrote:
> Am Freitag, 5. März 2010 21:59:31 schrieben Sie:
> > > I guess it's better if drivers don't set should_wakeup if unsure, but of course
> > > that's impossible to enforce.
> > 
> > That's the real question.  Ideally, drivers won't touch should_wakeup.  
> > How do we get there from here?
> 
> Enable it only for devices specifically designed for wakeup, that is
> keyboards, power buttons and WoL, perhaps also mice and modems.
> Are we far away from that?

I don't think we're very far from that.

Mice are known dangerous, especially the USB ones, though.

Rafael
