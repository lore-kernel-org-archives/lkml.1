Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGVRq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGVRq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZGVRq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:46:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:46106 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZGVRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s647REFf9lmZhxK0SBXk1Jeg/aYhf/M1eXQCgMdUXVR2qu9+Gm4+tuCDfflQCjN+No
         zh4/Q9eUSFZ76f5roTCUPWUefTuGxGBIf3alWI6XFbVihSCVYZa4Q2RHkChWpJReWmb1
         jrXqy1bs6CftMisVEXPqf+gYoxBOV/HaAXc/Q=
MIME-Version: 1.0
In-Reply-To: <1248207099-14583-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <200907111527.46441.david-b@pacbell.net>
	 <1248207099-14583-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Wed, 22 Jul 2009 19:46:24 +0200
Message-ID: <cd73a99e0907221046k5e435fd3m3cb1fd006c0385a7@mail.gmail.com>
Subject: Re: [PATCH] register at91_ether using platform_driver_probe
From: Andrew Victor <avictor.za@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       netdev@vger.kernel.org,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> at91ether_probe lives in .init.text, so using platform_driver_register
> to register it is wrong because binding a device after the init memory
> is discarded (e.g. via sysfs) results in an oops.
>
> As requested by David Brownell platform_driver_probe is used instead of
> moving the probe function to .devinit.text as proposed initially.
> This saves some memory, but devices registered after the driver is
> probed are not bound (probably there are none) and binding via sysfs
> isn't possible.


Acked-by: Andrew Victor <linux@maxim.org.za>
