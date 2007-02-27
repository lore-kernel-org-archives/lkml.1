Return-Path: <linux-kernel-owner+w=401wt.eu-S1751961AbXB0WY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbXB0WY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXB0WYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:24:55 -0500
Received: from mailin1.k-net.dk ([82.211.192.11]:2868 "EHLO mailin1.k-net.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbXB0WYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:24:54 -0500
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <200702272304.01756.rjw@sisk.pl>
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <200702272304.01756.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Tue, 27 Feb 2007 23:23:49 +0100
Message-Id: <1172615029.4865.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-27 at 23:04 +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> On Tuesday, 27 February 2007 19:45, Kristian Grønfeldt Sørensen wrote:
> > Hi.
> > 
> > PROBLEM: "BUG:" when resumimg from suspend-to-ram 
> > 	
> > My laptop have a problem with resuming from suspend-to-ram. 
> > It does not occur every time - most of the time, resume works without
> > any problem.at all.
> > 
> > After it occurs, the laptop refuses to go into suspend-to-ram mode until
> > next reboot.
> 
> What do you mean by "refuses"?  

As in it does not suspend when i close the lid. It just stays on.

> Are there any suspicious messages in
> dmesg?

No: This what i get just after the stacktrace: 

video bus notify
video bus notify
video bus notify
video bus notify
video bus notify
video bus notify
video bus notify
video bus notify
DEV: Unregistering device. ID = 'vcs7'
PM: Removing info for No Bus:vcs7
device_create_release called for vcs7
DEV: Unregistering device. ID = 'vcsa7'
PM: Removing info for No Bus:vcsa7
device_create_release called for vcsa7
DEV: registering device: ID = 'vcs7'
PM: Adding info for No Bus:vcs7
DEV: registering device: ID = 'vcsa7'
PM: Adding info for No Bus:vcsa7
DEV: Unregistering device. ID = 'vcs7'
PM: Removing info for No Bus:vcs7
device_create_release called for vcs7
DEV: Unregistering device. ID = 'vcsa7'
PM: Removing info for No Bus:vcsa7
device_create_release called for vcsa7


The "video bus notify" lines is from attempts to suspend the machine
once again, but as I described above, nothing happens - the computer
stays on.
The rest is from switches between VT's and X.

> > The system is a Debian unstable running with a self-compiled 2.6.20
> > kernel downloaded from kernel.org. 
> > 
> > I've only tried suspend-to-ram on 2.6.20 so I don't know whether or not
> > other versions might have the same problem.
> > 
> > I'm not subscribed to the list. Please CC me.
> 
> I guess one of the drivers you use goes awry at some point.  Please provide
> us with more information (like dmesg output after a failing resume).

See the above dmesg snippet.

/Kristian

