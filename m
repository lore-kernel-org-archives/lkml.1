Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYLEXGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYLEXGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 18:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYLEXFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 18:05:51 -0500
Received: from gate.compton.nu ([217.169.19.106]:56695 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbYLEXFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 18:05:50 -0500
Message-ID: <4939B3C3.8060205@compton.nu>
Date: Fri, 05 Dec 2008 23:05:39 +0000
From: Tom Hughes <tom@compton.nu>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu> <4936DD78.4090501@compton.nu> <200812040257.09099.trenn@suse.de>
In-Reply-To: <200812040257.09099.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spam detection software, running on the system "gosford.compton.nu", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Thomas Renninger wrote: > The biggest problem I see with these
	"special" ACPI cpufreq interface is: > Can there be Asus/eeepcs which provide
	these ACPI functions (maybe dummies on > future machines?), but can still
	be switched via the spec conform and more > efficient acpi-cpufreq driver
	via PSS tables? [...] 
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

> The biggest problem I see with these "special" ACPI cpufreq interface is:
> Can there be Asus/eeepcs which provide these ACPI functions (maybe dummies on
> future machines?), but can still be switched via the spec conform and more 
> efficient acpi-cpufreq driver via PSS tables?

So should we tie this driver to particular DMI signature(s) then? As far 
as I know it is only useful for the Eee 900 and possibly the 701 when 
running later BIOSes.

> BTW: Have you tried out how much power (or at least battery life time) you
> win?

Running with wifi and the screen off, and the CPU busy (doing m5sum of 
/dev/zero) I get 2:37 run time at 900MHz and 3:09 at 630MHz so the 
increase in run time is about 20% on that test.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://www.compton.nu/
