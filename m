Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbXKRWYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbXKRWYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 17:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbXKRWYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 17:24:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbXKRWYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 17:24:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Date: Sun, 18 Nov 2007 23:42:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711181203220.5712-100000@netrider.rowland.org> <200711182328.00570.rjw@sisk.pl> <4740B8E9.4030903@gmail.com>
In-Reply-To: <4740B8E9.4030903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711182342.18816.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of November 2007, Jiri Slaby wrote:
> On 11/18/2007 11:27 PM, Rafael J. Wysocki wrote:
> > You can use a global variable to switch the logging only before the CPU
> > hotunplug done by the suspend code.  You just need to hack
> > disable_nonboot_cpus() for that.
> 
> If I understand you correctly, that's what BUBAK variable is there for.

Ah, yes.

-ETOOTIRED

> But it is still called again and again while the suspend code runs...

You can count the number of calls and then make it print the information for
the last, say, 20 of them.

Greetings,
Rafael
