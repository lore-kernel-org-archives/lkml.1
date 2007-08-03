Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbXHCMcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbXHCMcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXHCMcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:32:24 -0400
Received: from sumo.dreamhost.com ([66.33.216.29]:60261 "EHLO
	sumo.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516AbXHCMcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:32:23 -0400
Message-ID: <46B31F03.80908@dawes.za.net>
Date: Fri, 03 Aug 2007 14:26:43 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Oliver Neukum <oliver@neukum.org>, David Brownell <david-b@pacbell.net>,
       Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain
 device classes
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org>	<200708022301.08719.david-b@pacbell.net>	<20070803112824.GA16802@srcf.ucam.org>	<200708031344.03282.oliver@neukum.org> <20070803120418.GB16802@srcf.ucam.org>
In-Reply-To: <20070803120418.GB16802@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Aug 03, 2007 at 01:44:02PM +0200, Oliver Neukum wrote:
>> Am Freitag 03 August 2007 schrieb Matthew Garrett:
>>> It's certainly possible to do that, but it's also possible to have a 
>>> userspace solution that whitelists devices. The question is whether the 
>>> default kernel behaviour should be "Save power, but potentially break 
>>> some of my devices" or "Don't break my devices, but use some more 
>>> powre".
>> If both options have drawbacks, IMHO we follow the standard, which
>> says that devices must support suspension.
> 
> Except that lots of hardware doesn't follow the standard in this 
> respect, otherwise we wouldn't be having this discussion. Personally, I 
> think "Will break an unknown number of devices" is a significantly 
> larger drawback than "Will consume a small quantity of additional 
> power".
> 

I guess the question could be phrased:

Which one is more likely to conclude at some point?

That is, if we blacklist by default, we consume that additional power 
indefinitely, because it is unlikely that people will report "my machine 
uses 200mW more than I think it should", and thus we are unlikely to 
build up knowledge of exactly which devices/classes should be blacklisted.

Compare that to:

"My USB printer broke, guess I'd better report it to LKML".

The first option is unlikely to ever reach a satisfactory conclusion, 
whereas the second one is quite likely to flush out the guilty parties 
within a relatively short time.

FWIW.

Rogan
