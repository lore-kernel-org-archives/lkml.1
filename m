Return-Path: <linux-kernel-owner+w=401wt.eu-S1765952AbXJZVQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765952AbXJZVQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761623AbXJZVP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:15:58 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:49903 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758688AbXJZVP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:15:57 -0400
Date: Fri, 26 Oct 2007 23:15:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] hwmon/f75375s.c: buggy if()
Message-ID: <20071026231555.7069639d@hyperion.delvare>
In-Reply-To: <20071026111423.GA16559@kos.to>
References: <20071017195439.GD3778@stusta.de>
	<20071017204508.GA32110@kos.to>
	<20071018133744.GC3526@jupiter.solarsys.private>
	<20071019143754.0aa4483b@hyperion.delvare>
	<20071024115034.GA5797@kos.to>
	<20071025022529.GF30546@jupiter.solarsys.private>
	<20071025114814.GA2452@kos.to>
	<20071026103647.78f44826@hyperion.delvare>
	<20071026111423.GA16559@kos.to>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 14:14:23 +0300, Riku Voipio wrote:
> On Fri, Oct 26, 2007 at 10:36:47AM +0200, Jean Delvare wrote:
> > Patch looks correct, however it doesn't apply on top of Mark's tree. I
> > was able to get it to apply by reverting "(f75375s) fix pwm mode
> > setting" first, but then the build fails. Presumably the other f75375s
> > patches interact badly. Can you please respin this patch on top of
> > Mark's tree (i.e. on top the the 4 other f75375s patches you sent since
> > the -rc1 merge)? Thanks.
> 
> The surrounding code had wandered to another function, so it's suprising
> it applied at all. Here's respin.

Patch looks OK, thanks.

Acked-by: Jean Delvare <khali@linux-fr.org>

Riku, I have 14 patches posted to the lm-sensors list pending for
review. Would you mind reviewing one of them? Thanks.

-- 
Jean Delvare
