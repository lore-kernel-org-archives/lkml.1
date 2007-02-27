Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXB0Wbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXB0Wbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXB0Wbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:31:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38486 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXB0Wbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:31:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kristian =?iso-8859-15?q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Date: Tue, 27 Feb 2007 23:34:07 +0100
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <1172601905.5428.28.camel@localhost.localdomain> <200702272304.01756.rjw@sisk.pl> <1172615029.4865.7.camel@localhost.localdomain>
In-Reply-To: <1172615029.4865.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702272334.07985.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 February 2007 23:23, Kristian Grønfeldt Sørensen wrote:
> On Tue, 2007-02-27 at 23:04 +0100, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Tuesday, 27 February 2007 19:45, Kristian Grønfeldt Sørensen wrote:
> > > Hi.
> > > 
> > > PROBLEM: "BUG:" when resumimg from suspend-to-ram 
> > > 	
> > > My laptop have a problem with resuming from suspend-to-ram. 
> > > It does not occur every time - most of the time, resume works without
> > > any problem.at all.
> > > 
> > > After it occurs, the laptop refuses to go into suspend-to-ram mode until
> > > next reboot.
> > 
> > What do you mean by "refuses"?  
> 
> As in it does not suspend when i close the lid. It just stays on.

Hm, it doesn't seem to attempt to suspend.  Can you just do
"echo mem > /sys/power/state" when it's in that state and see what happens?

Rafael
