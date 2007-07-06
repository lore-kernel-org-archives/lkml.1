Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbXGFGK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbXGFGK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbXGFGKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:10:50 -0400
Received: from ppp198-178.static.internode.on.net ([59.167.198.178]:50087 "EHLO
	anu.rimspace.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbXGFGKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:10:49 -0400
X-Greylist: delayed 1524 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2007 02:10:49 EDT
From: Daniel Pittman <daniel@rimspace.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
In-Reply-To: <20070705142318.GA22598@srcf.ucam.org> (Matthew Garrett's message
	of "Thu, 5 Jul 2007 15:23:18 +0100")
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com>
	<200707051528.34754.oliver@neukum.org>
	<20070705134632.GA22177@srcf.ucam.org>
	<200707051609.25887.rjw@sisk.pl>
	<20070705142318.GA22598@srcf.ucam.org>
User-Agent: Gnus/5.110007 (No Gnus v0.7) XEmacs/21.5-b28 (fuki, linux)
Date: Fri, 06 Jul 2007 15:45:17 +1000
Message-ID: <87r6nmozki.fsf@rimspace.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:
> On Thu, Jul 05, 2007 at 04:09:24PM +0200, Rafael J. Wysocki wrote:
>> On Thursday, 5 July 2007 15:46, Matthew Garrett wrote:
>> > I have a model for STD that avoids the need to freeze the entirity of 
>> > userspace, but I need to find some more time to flesh it out.
>> 
>> You can just describe it, as far as I'm concerned. :-)
>
> The basic model is that nobody's really described a use-case where we 
> actually care about restoring system state. What people want is to be 
> able to restore application state. So, arguably, what we want isn't to 
> save the entire kernel state and application state in one go because we 
> can reconstruct a huge amount of that afterwards.

[...]

> I've mocked up a basic implementation using cryopid, but it's somewhat
> limited by the lack of support for sockets. I'd like to move more of
> the smarts into the kernel (Hurray, checkpointing!) and then see how
> much hardware support ends up horifically broken.

You might want to look at the checkpoint / migration support in the
OpenVZ kernel in relation to this.  That does work to dump the state of
a running "virtual environment" complete with applications to disk, move
it to another running kernel and restore the content.

That might, perhaps, help with the prototype of this?

Regards,
	Daniel
