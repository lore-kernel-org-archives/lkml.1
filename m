Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbZDFUXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbZDFUXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDFUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:23:22 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:38456 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZDFUXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:23:21 -0400
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 16:23:20 EDT
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH] acer-wmi: don't bother loading on unsupported systems
Date: Mon, 6 Apr 2009 20:53:11 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.28.8; KDE/4.2.1; x86_64; ; )
Cc: aceracpi@googlegroups.com, linux-kernel@vger.kernel.org
References: <200904060940.16889.jarod@redhat.com>
In-Reply-To: <200904060940.16889.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904062053.12303.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 06 Apr 2009 19:53:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009 14:40:16 Jarod Wilson wrote:
> So have acer-wmi just bail on unsupported systems -- includes only my
> particular model of the Aspire One atm, but a larger list of unsupported
> systems can be found here:
>
> http://code.google.com/p/aceracpi/wiki/SupportedHardware
>
> This might well become unnecessary once the WMI sysfs interface mentioned
> in acer-wmi.c exists and the wild-card dmi modalias is gone, but for now...
> I prefer to have working wireless, and this isn't exactly an obvious root
> cause. I lack the hardware to further extend the blacklist, but doing so is
> trivial. Whether or not loading acer-wmi actually negatively impacts
> machines other than the AAO is unknown at this time.

NAK.

An equivalent patch to this was submitted to the ACPI tree two days ago (which 
blacklists both the known Aspire One DMI entries) and is now upstream (and 
will also be backported to the next stable release).

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a74dd5fdabcd34c93e17e9c7024eeb503c92b048

(The Aspire One is special as, unlike other Acer laptops which are 
unsupported, it provides the ACPI-WMI inteface we're trying to match on, so it 
really does have to be blacklisted - so WMI matching won't help in this 
particular case).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
