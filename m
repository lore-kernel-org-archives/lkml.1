Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYKJS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYKJS6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 13:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYKJS6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 13:58:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42792 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYKJS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:58:15 -0500
Date: Mon, 10 Nov 2008 20:07:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: CONFIG_NUMA breaks hibernation on x86-32 with PAE
Message-ID: <20081110190718.GB3810@one.firstfloor.org>
References: <20081109140726.GB1786@ucw.cz> <20081110125335.GB28643@elte.hu> <878wrrpic1.fsf@basil.nowhere.org> <200811101933.26110.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811101933.26110.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 07:33:25PM +0100, Rafael J. Wysocki wrote:
> On Monday, 10 of November 2008, Andi Kleen wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > i can only suggest some stupid tweaking of the above options - for 
> > > example, does the bug scenario change in any way if you switch it over 
> > > to CONFIG_DISCONTIGMEM=y ?
> > 
> > iirc we removed that some time ago so it would probably need some
> > source hackery. There is only vmemmap or flat left.
> 
> No, it's there. :-)

You're right, i was off in 64bit only land  again.

-Andi

-- 
ak@linux.intel.com
