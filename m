Return-Path: <linux-kernel-owner+w=401wt.eu-S934522AbXKPAok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934522AbXKPAok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbXKPAoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:44:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50212 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764101AbXKPAob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:44:31 -0500
Date: Thu, 15 Nov 2007 16:38:36 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Message-ID: <20071116003836.GA24490@kroah.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <473B5987.60904@gmail.com> <200711142248.59547.rjw@sisk.pl> <473CDD6D.8080008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473CDD6D.8080008@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 12:59:41AM +0100, Jiri Slaby wrote:
> On 11/14/2007 10:48 PM, Rafael J. Wysocki wrote:
> > On Wednesday, 14 of November 2007, Jiri Slaby wrote:
> >> On 11/14/2007 02:59 AM, Andrew Morton wrote:
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc2/2.6.24-rc2-mm1/
> >> Doesn't suspend for me (neither broken-out-2007-11-13-04-14 did) on x86_64.
> >> echo mem >/sys/power/state
> >> causes shut down of disk(s) and blinking cursor on 1,1 position.
> >> The last working was 2.6.23-rc8-mm2. I haven't tested
> >> 2.6.23-mm1, since it didn't work for me.
> > 
> > Does the current mainline work?
> 
> Yes.
> 
> The offending -mm patch is
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
> 
> 2.6.24-rc2-mm1 minus it works just fine; PROVE_LOCKING shows nothing new when
> the patch is applied.

Thanks for tracking this down.  Alan, any thoughts?

thanks,

greg k-h
