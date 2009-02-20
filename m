Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZBTRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZBTRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZBTRJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:09:17 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:39051 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZBTRJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:09:16 -0500
Message-ID: <499EE3BA.7070105@cfl.rr.com>
Date: Fri, 20 Feb 2009 12:09:14 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com> <20090220160843.GF4834@alberich.amd.com> <20090220163844.GG4834@alberich.amd.com>
In-Reply-To: <20090220163844.GG4834@alberich.amd.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> On Fri, Feb 20, 2009 at 05:08:43PM +0100, Andreas Herrmann wrote:
>> On Fri, Feb 20, 2009 at 10:43:03AM -0500, Mark Hounschell wrote:
>>> Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1
>>> 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux)
>>> ) #7 SMP PREEMPT Fri Feb 2 0 09:01:54 EST 2009
>> Here I doubt that's the right kernel -- at least it was not built today.
>> Can you please double check this.
> 
> Oops, your kernel was built today.
> Have overlooked it as there was a newline between "2" and "0".
> Sorry for the noise.
> 
> But still wondering where's the debug output. I've applied the patch
> both to .29-rc5 and with some fuzziness to .28.4 and on my system the
> output is visible (e.g. with dmesg). Ah, ... of course you need to use
> "debug" kernel parameter as well.  Otherwise the KERN_DEBUG messages
> are not shown on the serial console.
> 
> Please, can you retry using "hpet=debug debug apic=debug".
> Thanks.
> 
> 
> Andreas
> 
> 
> 

Ah yes, ok....

It will be forthcoming.
Mark
