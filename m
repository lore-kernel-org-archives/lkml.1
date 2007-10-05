Return-Path: <linux-kernel-owner+w=401wt.eu-S1762520AbXJESpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520AbXJESpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 14:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759076AbXJESpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 14:45:13 -0400
Received: from trinity.develer.com ([89.97.188.34]:54521 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890AbXJESpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 14:45:11 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2007 14:45:10 EDT
Message-ID: <470684A0.2040604@codewiz.org>
Date: Fri, 05 Oct 2007 14:38:24 -0400
From: Bernardo Innocenti <bernie@codewiz.org>
Organization: http://www.codewiz.org/
User-Agent: Thunderbird 2.0.0.6 (X11/20070925)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jordan Crouse <jordan.crouse@amd.com>,
       Andres Solomon <dilinger@queued.net>,
       OLPC Development <devel@laptop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] GEODE: decouple sleep/resume from powerdown/powerup
References: <1190589101921-git-send-email-bernie@codewiz.org> <20071005131530.GC7397@ucw.cz>
In-Reply-To: <20071005131530.GC7397@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2007 09:15 AM, Pavel Machek wrote:

>> This patch merges the fb_powerup and fb_powerdown hooks in a single
>> operation fb_power with an additional "state" parameter ranging
>> from 0 (running) to 3 (poweroff).
> 
> No, please don't. Having int with 0/3 being valid specifying what to
> do is evil.
> 
> enum is less evil, but what's wrong about having 3 functions?

Later on, the patch was reworked by Jordan Crouse to use
the fb_blank hook instead, which already has enough states.

So the fb_powerup/fb_powerdown hooks, which were not yet
upstream anyway, died off in the process.

-- 
 \___/
 |___|  Bernardo Innocenti - http://www.codewiz.org/
  \___\ One Laptop Per Child - http://www.laptop.org/
