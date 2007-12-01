Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbXLAXsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbXLAXsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 18:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXLAXsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 18:48:25 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55866 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXLAXsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 18:48:24 -0500
Date: Sat, 1 Dec 2007 15:46:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 20000+ wake-ups/second in 2.6.24.   Bug?
Message-ID: <20071201154646.5a288c9e@laptopd505.fenrus.org>
In-Reply-To: <4751F1AB.2060801@rtr.ca>
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com>
	<20071130142058.816d1693.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
	<4750CC78.9070105@rtr.ca>
	<20071130190227.1976e682@laptopd505.fenrus.org>
	<4750D180.6080001@rtr.ca>
	<20071130191816.3e744205@laptopd505.fenrus.org>
	<4750D585.1030200@rtr.ca>
	<4750D899.4020905@rtr.ca>
	<4751F1AB.2060801@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2007 18:43:39 -0500
Mark Lord <lkml@rtr.ca> wrote:

> 
> Dagnabbit.. it's done it again.. went from 100-200 wakeups/sec
> back up to 20000+ wakeups/sec.  This time *with* the powertop patches
> in place.
> 
> Somethings broken in there, but I don't know what.
> Or how to make it happen on demand.. it's fine after rebooting again.
> 
> ???
> 
> At least now I know to look when I hear the fan turning on
> when the system is otherwise supposed to be idle..
> 
> 2.6.23 did not have this problem.

actually we have reports of 2.6.23 having the exact same problem.
The thing is, "something" is causing the system to go into a state
where the cpu throws us right out of the C-state the kernel asks for.

Some people have seen that not loading yenta at all will just make this
not happen at all...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
