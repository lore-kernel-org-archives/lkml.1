Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYJOHup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYJOHup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYJOHui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:50:38 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:6420 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYJOHuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:50:37 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48F5A0C8.1080102@tremplin-utc.net>
Date: Wed, 15 Oct 2008 09:50:32 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: lm-sensors@lm-sensors.org, kernel list <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, Tejun Heo <tj@kernel.org>,
       Yan Burman <burman.yan@gmail.com>
Subject: Re: Accelerometer driver for HP laptops
References: <48C984F5.5000804@tudelft.nl> <200809120736.06594.trenn@suse.de> <48CAD89F.1050806@tremplin-utc.net> <20081015072511.GA20607@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081015072511.GA20607@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:
> Hi!
> 
> I took a look at the driver, and it seems to work for me... I'd like
> to get it to the mainline...
> 
>>>> Attached is our work-in-progress version of the driver for a fourth take
>>>> on the LKML (it used to be mdps). It works really fine, with lots of
>>>> "goodies" (like automatically convert the axes to fit to a standard,
>>>> automatic power-off of the device when not in used) excepted the
>>>> interrupt support for free-fall detection.
> 
> I wonder if mdps was really a better name? Driver is HP-specific
> (because of the ACPI usage), not really chip specific... and lis3lv02d
> looks like an alphabet soup to me...
> 
> Ok, it is a bit chip-specific, too...
Yes, the point is that several people got interested in adding to the
driver SPI and I²C support last time I submitted the driver. I did my
best to concentrate the ACPI stuff only to some 3 or 4 small functions,
so that it can be be easily done.

> 
> What are the next plans... lm_sensors is listed as orphan in
> MAINTAINERS, so I guess I'll clean it up a tiny bit then submit to akpm?
Yes I've hold things up because I can't get the free-fall detection
working correctly on my laptop. However here is the merge window (not
that it matters that much with new drivers), free-fall is "just" not
always detected, and there are lots of people who have showed interest
in the driver. Fixing the last small things can be done once in Linus'
tree as well!

I've got already a changelog ready. Give me a couple of days to clean
things up and I'll send it to akpm myself :-)

See you,
Eric
