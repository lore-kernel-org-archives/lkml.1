Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYDNDqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYDNDqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 23:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbYDNDqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 23:46:15 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:42307 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751910AbYDNDqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 23:46:14 -0400
Message-ID: <4802D383.20401@gawab.com>
Date: Sun, 13 Apr 2008 20:46:11 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200804011322.58259.jbarnes@virtuousgeek.org> <47FC4C9B.1030703@gawab.com> <200804090824.35825.jbarnes@virtuousgeek.org>
In-Reply-To: <200804090824.35825.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> You could try using the X vesa driver instead of the intel driver...

Ok, so I tried with the vesa X.org driver and it never had the blank screen problem (so far).
There were some screen distortions on mode change but no blank screen.
I noticed that when using the vesa X.org driver the i915 kernel module didn't load.

I think we're getting closer! It seems like it's not a kernel regression but a bug in the intel Xorg driver.
Or maybe an interaction between the i915 DRM kernel module (>=2.6.25) and the intel X.org driver,
because it only happens with the 2.6.25 kernel, and I'd think if it was only an X driver bug,
then it should've happened on other kernel versions.

Justin

