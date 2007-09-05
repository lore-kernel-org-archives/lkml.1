Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbXIEA1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbXIEA1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 20:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXIEA1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 20:27:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20737 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbXIEA1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 20:27:31 -0400
Subject: Re: 2.6.22.6 + rt9: suspend/hibernate not working
From: Daniel Walker <dwalker@mvista.com>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       planetccrma@ccrma.Stanford.EDU
In-Reply-To: <1188951154.26511.90.camel@cmn3.stanford.edu>
References: <1188951154.26511.90.camel@cmn3.stanford.edu>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 17:15:09 -0700
Message-Id: <1188951309.4442.1.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 17:12 -0700, Fernando Lopez-Lezcano wrote:
> Hi Ingo... I'm getting reports from some of my Planet CCRMA users (which
> I confirmed) that the latest rt kernel I released has broken suspend
> (tested on fc6 & fc7, stock Fedora kernel works fine - the rt
> configuration files are virtual clones as far as possible of the
> standard Fedora kernel config files). 
> 
> I don't know where to start debugging this. When suspend is initiated it
> freezes with a "Stopping tasks ... " message in the text console - a
> hard power cycle is the only way to get the machine back to normal. 
> 
> kernel/power/process.c seems to contain that string in the
> freeze_processes function so it looks like the freezer is not freezing
> tasks as no "done" message is ever printed. 
> 
> What could we do to help?

If you have high resolution timers enabled you could try disabling it,
and see if the problem persists .

Daniel

