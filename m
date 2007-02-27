Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXB0XNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXB0XNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXB0XNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:13:44 -0500
Received: from mailin1.k-net.dk ([82.211.192.11]:3429 "EHLO mailin1.k-net.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXB0XNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:13:43 -0500
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <200702272334.07985.rjw@sisk.pl>
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <200702272304.01756.rjw@sisk.pl>
	 <1172615029.4865.7.camel@localhost.localdomain>
	 <200702272334.07985.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Wed, 28 Feb 2007 00:12:40 +0100
Message-Id: <1172617960.4587.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 23:34 +0100, Rafael J. Wysocki wrote:
> On Tuesday, 27 February 2007 23:23, Kristian Grønfeldt Sørensen wrote:
> > On Tue, 2007-02-27 at 23:04 +0100, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > On Tuesday, 27 February 2007 19:45, Kristian Grønfeldt Sørensen wrote:
> > > > Hi.
> > > > 
> > > > PROBLEM: "BUG:" when resumimg from suspend-to-ram 
> > > > 	
> > > > My laptop have a problem with resuming from suspend-to-ram. 
> > > > It does not occur every time - most of the time, resume works without
> > > > any problem.at all.
> > > > 
> > > > After it occurs, the laptop refuses to go into suspend-to-ram mode until
> > > > next reboot.
> > > 
> > > What do you mean by "refuses"?  
> > 
> > As in it does not suspend when i close the lid. It just stays on.
> 
> Hm, it doesn't seem to attempt to suspend.  Can you just do
> "echo mem > /sys/power/state" when it's in that state and see what happens?

Hmmm. That works. (except for video restore - forgot to save
vbe-state :-( )
Resume also worked. 

/Kristian
