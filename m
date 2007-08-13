Return-Path: <linux-kernel-owner+w=401wt.eu-S936896AbXHMUVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936896AbXHMUVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761631AbXHMUVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:21:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37586 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760945AbXHMUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:21:14 -0400
Date: Mon, 13 Aug 2007 16:21:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arkadiusz Miskiewicz <arekm@maven.pl>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: resume from ram much slower
In-Reply-To: <20070813195507.GB18731@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0708131620090.2553-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Pavel Machek wrote:

> Hi!
> 
> > [S-T-R wizards CC'ed]
> > 
> > On 10/08/07, Arkadiusz Miskiewicz <arekm@maven.pl> wrote:
> > > Hi,
> > >
> > > Starting 1-2 weeks ago I have very long resume from
> > > ram times. It takes more than 1 min to resume. Does anyone see such behaviour?
> > >
> > > Kernel from yesterday git, thinkpad z60m, suspend.sf.net tools 20070801
> > >
> > > "ACPI handle has no context!" are interesting btw.
> 
> 
> Usual way to debug it is to unload as many modules as possible, to
> find out if it is caused by one of them...
> 
> If that does not help, you can try playing with git to find out which
> commit caused the regression.

Another possibility: Compare the timestamps in your log with a log from 
an earlier kernel, to find out exactly where the extra delay occurred.

Alan Stern

