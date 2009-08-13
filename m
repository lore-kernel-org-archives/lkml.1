Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZHMKtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZHMKtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZHMKtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:49:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49835 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZHMKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:49:30 -0400
To: Bernhard Walle <bernhard.walle@gmx.de>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
	<20090812124659.GA4808@mail1.bwalle.de> <4A837F49.9060003@redhat.com>
	<20090813053952.GA9037@mail1.bwalle.de> <4A83CCAA.1030302@redhat.com>
	<20090813090335.GA9502@mail1.bwalle.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 13 Aug 2009 03:49:24 -0700
In-Reply-To: <20090813090335.GA9502@mail1.bwalle.de> (Bernhard Walle's message of "Thu\, 13 Aug 2009 11\:03\:35 +0200")
Message-ID: <m1k5182dl7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: bernhard.walle@gmx.de, avorontsov@ru.mvista.com, mingo@elte.hu, fenghua.yu@intel.com, akpm@linux-foundation.org, andi@firstfloor.org, nhorman@redhat.com, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, amwang@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernhard Walle <bernhard.walle@gmx.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 0/8] V3 Implement crashkernel=auto
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bernhard.walle@gmx.de> writes:

> * Amerigo Wang <amwang@redhat.com> [2009-08-13 10:19]:
>> Sure.
>> 
>> But if we disable CONFIG_KEXEC_AUTO_RESERVE, that means
>> crashkernel=auto will be invalid, this is the same as it is now.
>
> Ok, but since 'crashkernel=auto' is not used today, nobody has
> 'crashkernel=auto' in the bootloader configuration. So I don't see any
> practial advantage of that config option.
>
> Eric, what's your opinion on that, do we need a config option
> CONFIG_KEXEC_AUTO_RESERVE or could we just implement that feature
> unconditionally (if CONFIG_KEXEC is enabled, of course).

The only reason I can see the option going away would be
a dependency on CONFIG_HOTPLUG_MEM.

Eric
