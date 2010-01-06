Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103Ab0AFTOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0AFTOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936Ab0AFTOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:14:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab0AFTOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:14:31 -0500
Date: Wed, 6 Jan 2010 11:14:25 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jean Delvare <khali@linux-fr.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: i2c_powermac: Kernel access of bad area
In-Reply-To: <20100106173745.57207520@hyperion.delvare>
Message-ID: <alpine.DEB.2.01.1001061107350.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912281934170.3483@bogon.housecafe.de> <1262079255.2173.216.camel@pasglop> <20100106173745.57207520@hyperion.delvare>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX19mnq2zAzVe9SZZUsH78X35ivxS+EiVbyng1kk
 bbSsgAV+eMaC5FWW+ag9DcC0aGoQaLxjtr49SAX4KVwYXL1Ply
 dr/GPXKKj+ua4e2LbUqVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 at 17:37, Jean Delvare wrote:
> Christian, did you happen to try removing the i2c-powermac driver
> before?

Well, I definitely removed the driver before, but I'm not sure if I ever 
read the /sys files after doing this :-\

> I am curious if this is a recent problem, possibly caused by
> changes to the i2c stack, or if older kernels already had this problem
> and nobody ever noticed. I suspect the latter.

Fair question, but I really could't tell. I realize a bisection would be 
helpful, but I don't think I'll have to time to do this on this machine 
(it's a PowerBook G4, but kernel still compilation usually takes ~30min) 
and I'm not sure that I care _that_ much about this particular issue. 
I just wanted to report this one, for the sake of the archives, as noone 
else seems to be bothered by it anyway...

> I think that sysfs files creation should be moved to the end of
> probe_thermostat() and sysfs files removal should be moved to the
> beginning of remove_thermostat(). Something like the totally untested
> patch below (no ppc machine at hand):

OK, thanks Jean - I'll give it a try later today and let you know.


Thanks again,
Christian.

-- 
BOFH excuse #398:

Data for intranet got routed through the extranet and landed on the internet.
