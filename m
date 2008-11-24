Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYKXQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYKXQrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYKXQrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:47:11 -0500
Received: from gate.compton.nu ([217.169.19.106]:53099 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKXQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:47:10 -0500
Message-ID: <492ADA81.4070904@compton.nu>
Date: Mon, 24 Nov 2008 16:46:57 +0000
From: Tom Hughes <tom@compton.nu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu> <200811241613.25557.trenn@suse.de> <200811241736.53067.trenn@suse.de>
In-Reply-To: <200811241736.53067.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spam detection software, running on the system "gosford.compton.nu", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Thomas Renninger wrote: > Oh, they are part of this general
	Asus \\_SB.ATKD device, which is only > used by asus_laptop.c until now?
	I believe eeepc-laptop is also accessing the same device - at least it is
	calling other methods defined in the same part of the DSDT although it doesn't
	seem to be using that name to reach them. [...] 
	Content analysis details:   (-2.6 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.0 NO_RELAYS              Informational: message was not relayed via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:

> Oh, they are part of this general Asus \\_SB.ATKD device, which is only
> used by asus_laptop.c until now?

I believe eeepc-laptop is also accessing the same device - at least it 
is calling other methods defined in the same part of the DSDT although 
it doesn't seem to be using that name to reach them.

> Some more questions:
> Why are they providing their own cpufreq interface and not following the
> spec (providing _PSS, ..)?
> Could it be that you are only throttling the CPU?
>
> Are these functions already used by the ACPI tables internally?
>   - could be dangerous
>   - could be helpful -> Is there some upper level device/interface in ASL?
> 
> Could it happen that upcoming machines provide this interface (the two ACPI 
> functions) and also can do real CPU frequency/volt switching, e.g. via 
> acpi-cpufreq?

Well the recent eee's are all Atom based, which I assume has proper 
SpeedStep support but the early ones have a Celeron processor.

The history is that the original eee, the 701, was underclocking a 
900MHz CPU at 630Mhz and in the 900 they added support for running at 
full speed with the BIOS able to switch between the two speeds. I assume 
it just changes the clock multiplier or something.

The 901 and later of course use the Atom and presumably work differently.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://www.compton.nu/
