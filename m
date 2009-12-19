Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZLSXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZLSXXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZLSXXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:23:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451AbZLSXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:23:32 -0500
Date: Sat, 19 Dec 2009 15:23:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <200912200010.19899.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912191521180.3712@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912091729530.2672-100000@iolanthe.rowland.org> <200912192233.44575.rjw@sisk.pl> <A37A0A6F-3662-40C9-BE1F-B9F6A38CD80B@gmail.com> <200912200010.19899.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 20 Dec 2009, Rafael J. Wysocki wrote:
> 
> Well, I guess this is the example of the off-tree dependencies that actually
> matter Linus wanted. :-)

It's also the kind of dependency where I say "if we get into these kinds 
of messes, then the whole async crap isn't worth it".

Really. Having to try to match things up with ACPI and PnP is a nightmare. 
Especially since I doubt Windows does anything like this, which means that 
there's no reason for BIOS vendors to do the tables so that we'd even 
know.

			Linus
