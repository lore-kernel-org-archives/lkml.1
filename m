Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZHaNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZHaNLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZHaNLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:11:38 -0400
Received: from rtr.ca ([76.10.145.34]:47079 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZHaNLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:11:38 -0400
Message-ID: <4A9BCC0B.1010107@rtr.ca>
Date: Mon, 31 Aug 2009 09:11:39 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Mike Mohr <akihana@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: expresscard hotplug not working
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com> <4A96819D.7060708@rtr.ca> <20090830225542.GB901@srcf.ucam.org> <4A9BC239.9060009@rtr.ca> <4A9BC5FB.20000@rtr.ca> <20090831125609.GA11121@srcf.ucam.org>
In-Reply-To: <20090831125609.GA11121@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Aug 31, 2009 at 08:45:47AM -0400, Mark Lord wrote:
> 
>> With acpiphp loaded, hotplug works on the ExpressCard slot
>> of my Dell i9400 notebook.  Well, it *mostly* works.
> 
> Ok, that's good.
> 
>> The part that is still b0rked is that inserted cards get
>> "forgotten" about over suspend/resume (RAM) cycles.
> 
> I can entirely believe that that's broken. Thanks, I'll take a look at that.
..

Great!  Email me directly (or CC: me) if/when you'd like some more testing.

Another thing that could be a factor here, is that neither method
(acpiphp or pciehp) seems "automatic".  The user has to know to load
one or the other module, or at least manually add them to /etc/modules.

This could account for some reports of the mechanism failing.

Shouldn't one or the other module be loaded automatically somehow
when a system has hotpluggable slots?

Probably a chicken-and-egg issue, I suppose, or something for a distro to fuss over.

Cheers
