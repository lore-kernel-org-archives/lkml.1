Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbYBWSph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbYBWSph (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 13:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbYBWSp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 13:45:27 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756064AbYBWSp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 13:45:26 -0500
Date: Sat, 23 Feb 2008 10:43:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Romano Giannetti <romano@dea.icai.upcomillas.es>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Introduce PM_EVENT_HIBERNATE (was: Re: i915 hibernation
 patch (was: Re: 2.6.25-rc2 System no longer ...))
In-Reply-To: <200802231913.27592.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0802231041510.21332@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <alpine.LFD.1.00.0802221805540.21332@woody.linux-foundation.org> <b6a2187b0802222036i33d5bcc2n4e3bafd6d846cc09@mail.gmail.com> <200802231913.27592.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
> 
> Thanks for testing.  Below is the final version of the patch with a changelog
> etc.

Thanks, applied. 

With this, I also find that I dislike the use of suspend/resume for 
freezing for STD a lot less. It's still too easy to get confused, but at 
least now drivers always have total knowledge about what is really going 
on. I'd not like this interface as a driver writer, but now it's not 
fundamentally broken any more, just slightly confusing.

			Linus
