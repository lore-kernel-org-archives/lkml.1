Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbZCLNsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbZCLNsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZCLNsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:48:41 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:24902 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626AbZCLNsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:48:41 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 09:48:40 EDT
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=rbuhbqZ5kRQld3SIeZJmRqHeBZebKXVIXAX2iZgAjo9uB7TpEYOgx0h7
   1bpnfTBfKCw6npUwJuT7+6cOlUvoiN0IjMauN8bwHw49Tbrq/+7vUfxTQ
   GPhIEVX4Skgo5LG;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,350,1233529200"; 
   d="scan'208";a="56138593"
X-IronPort-AV: E=Sophos;i="4.38,350,1233529200"; 
   d="scan'208";a="45083375"
Message-ID: <49B91066.3010000@fujitsu-siemens.com>
Date: Thu, 12 Mar 2009 14:38:46 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() SMI-safe (take
 3)
References: <20080724143151.GA32422@lenovo> <4889D767 <4889ED91.7050800@fujitsu-siemens.com> <200903121041.34746.jdelvare@suse.de>
In-Reply-To: <200903121041.34746.jdelvare@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

same answer as on Bugzilla...

> Sorry for replying to such an old thread, but did this patch go
> anywhere? I can't seem to find it in git. Was it somehow obsoleted
> by a different fix for the same issue (SMI flood during APIC
> calibration)? Or is the upstream kernel still affected?

We were asked for a solution for all affected architectures (in 
particular, also i386) which was more than we were able to do
at the time, given that the pressure had been reduced by finding a BIOS 
fix for the particular situation on system in question.

The APIC clock calibration code on i386 is more complex than x86_64, we 
saw no way to provide a high-quality, regression-safe, tested patch for 
that to upstream with a reasonable amount of effort.

That aside, I still think the x86_64 patch is fine and won't cause 
regressions. It just doesn't help on 32bit systems.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
