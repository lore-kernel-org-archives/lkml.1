Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbYBST4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbYBST4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbYBST4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:56:04 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:51505 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYBST4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:56:02 -0500
Date: Tue, 19 Feb 2008 11:55:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Karl Dahlke <eklhad@comcast.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Where to put adapters, /proc is cool
Message-Id: <20080219115550.23b7e481.randy.dunlap@oracle.com>
In-Reply-To: <20080119143945.eklhad@comcast.net>
References: <20080119143945.eklhad@comcast.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 14:39:45 -0500 Karl Dahlke wrote:

> > So without knowing what an adapter is in this context /proc
> > seems to be a bad choice.
> 
> The best explanation might be an example.
> I use my Jupiter speecha dapter all day, every day.
> It basically sends text to a speech synthesizer.
> It also has some virtual files.
> /proc/adapters/jupiter/synth can be used by a process
> to send text directly to the synthesizer.
> 
> echo hello world >/proc/adapters/jupiter/synth
> 
> And I hear hello world.

Like Jan said (ooooh, please use reply-to-all), the word "adapters"
is just too generic.  We have lots of other kinds of "adapters".

> I don't use this virtual file often, but sometimes it's nice.
> A background process on another vt can wake me up when it's done.
> And this is just one example.
> Other virtual files load firmware and dictionaries into the dectalk synth, and so on.
> Other people use virtual files in their adapters as well.
> Really, /proc is the only place for these virtual files that interact
> directly with the kernel and/or its modules;
> I just wanted a fixed place under /proc for adapters to live,
> like sys ttys scsi net, and so on.
> 
> >/proc is for processes (and was in the past used for all sort of crap).
> 
> I gather from this that you don't like the way people
> are using /proc for user/kernel communication.
> I suppose it's a matter of taste,
> but I think it is one of the very coolest things about linux, period.
> I don't have to create 27 new ioctl calls, and have them approved by everyone,
> and make sure they don't collide with 363 other ioctl calls, every time I want
> some new communication with the kernel or its drivers.
> I can read and write files under /proc.
> I'm sorry, but I think it's cool.
> 
> Cool or not, it seems to be here to stay,
> and I humbly suggest a standard location for adapters and their virtual files.
> /proc/adapters

So some driver(s) already uses /proc/adapters?  That's too bad.

It really doesn't belong in /proc, but even if it did, would
/proc/speech make any sense?  or /proc/synthesizer?


---
~Randy
