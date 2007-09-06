Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbXIFTzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbXIFTzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 15:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbXIFTzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 15:55:39 -0400
Received: from smtp1.Stanford.EDU ([171.67.22.28]:54024 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbXIFTzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 15:55:38 -0400
Subject: Re: 2.6.22.6 + rt9: suspend/hibernate not working
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, planetccrma@ccrma.Stanford.EDU,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <1189104143.10587.8.camel@cmn3.stanford.edu>
References: <1188951154.26511.90.camel@cmn3.stanford.edu>
	 <1188951309.4442.1.camel@imap.mvista.com>
	 <1189104143.10587.8.camel@cmn3.stanford.edu>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 12:55:35 -0700
Message-Id: <1189108535.10587.11.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 11:42 -0700, Fernando Lopez-Lezcano wrote:
> On Tue, 2007-09-04 at 17:15 -0700, Daniel Walker wrote:
> > On Tue, 2007-09-04 at 17:12 -0700, Fernando Lopez-Lezcano wrote:
> > > Hi Ingo... I'm getting reports from some of my Planet CCRMA users (which
> > > I confirmed) that the latest rt kernel I released has broken suspend
> > > (tested on fc6 & fc7, stock Fedora kernel works fine - the rt
> > > configuration files are virtual clones as far as possible of the
> > > standard Fedora kernel config files). 
> > > 
> > > I don't know where to start debugging this. When suspend is initiated it
> > > freezes with a "Stopping tasks ... " message in the text console - a
> > > hard power cycle is the only way to get the machine back to normal. 
> > > 
> > > kernel/power/process.c seems to contain that string in the
> > > freeze_processes function so it looks like the freezer is not freezing
> > > tasks as no "done" message is ever printed. 
> > > 
> > > What could we do to help?
> > 
> > If you have high resolution timers enabled you could try disabling it,
> > and see if the problem persists .
> 
> The problem is still there ("Stopping tasks ... " and nothing
> afterwards). 

Looks like it was a known problem (sorry about the noise), see:
  http://lkml.org/lkml/2007/8/25/117

It does fix the problem here as well. 
Ingo: is this still the right fix for 2.6.22.6 + rt9?

-- Fernando


