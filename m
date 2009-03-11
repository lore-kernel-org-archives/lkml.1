Return-Path: <linux-kernel-owner+w=401wt.eu-S1751638AbZCKOxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbZCKOxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZCKOxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:53:14 -0400
Received: from peruna.fi ([62.220.235.200]:52596 "EHLO peruna.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZCKOxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:53:13 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 10:53:13 EDT
From: Mika Tiainen <mikat@iki.fi>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow clock on AMD 740G chipset
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi>
	<20090310101807.GD20716@alberich.amd.com>
	<20090311100525.GE20716@alberich.amd.com>
	<49B7A79A.6090008@msgid.tls.msk.ru>
Date: Wed, 11 Mar 2009 16:43:11 +0200
In-Reply-To: <49B7A79A.6090008@msgid.tls.msk.ru> (Michael Tokarev's message
 of
	"Wed, 11 Mar 2009 14:59:22 +0300")
Message-ID: <87ocw8qfwg.fsf@divinity.mikat.iki.fi>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Mar 2009, Michael Tokarev wrote:

>> On Tue, Mar 10, 2009 at 11:18:07AM +0100, Andreas Herrmann wrote:
>>> On Tue, Jan 20, 2009 at 04:16:10PM +0200, Mika Tiainen wrote:
>>>> Hi,
>>>>
>>>> I built a new machine with Gigabyte GA-MA74GM-S2H motherboard that
>>>> ntpd can't keep synced. Could this be a kernel bug or is it a
>>>> hardware problem?
>>>>
>>>> Installed with Debian 2.6.27 kernel and currently running a self
>>>> built 2.6.28.1, both have the problem. It's falling behind over
>>>> 2s/15min:
>
>>> That's annoying but I can't really help you with this. Maybe using
>>> adjtimex as described in section 9.1.6 in
>>> http://support.ntp.org/bin/view/Support/KnownHardwareIssues is an
>>> option for you.
>
> And adjtimex helped me on all 3 machines.
> Running it in self-calibrate mode (that 70 sec thing)
> plus running ntpd was enough for me for now.

Yes, I'm also using adjtimex+ntpd now with 10024 tick for adjtimex.

> What's interesting is that some time ago it worked just fine,
> and, which is even more interesting, windows on this very
> hardware shows quite good time stability (WITHOUT setting
> the time using [s]ntp, its ntp client is disabled).

Something weird is definitely going on under Linux. I got it working by
chance in 2.6.28 _exactly_ once. Just booted normally and ntpd kept it
in time without any resets for the week that it was up, next boot with
the same kernel and it was again falling behind so I installed adjtimex.

There was no difference in dmesg between working and not working.

-- 
Mika Tiainen		Always be wary of any helpful item that
mikat@iki.fi		weighs less than its operating manual.
http://mikat.iki.fi	-- (Terry Pratchett, Jingo)
