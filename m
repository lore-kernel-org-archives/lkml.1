Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbZHEUHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbZHEUHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZHEUHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:07:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44857 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbZHEUHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:07:30 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>
	<20090805112133.6552.69619.sendpatchset@localhost.localdomain>
	<87zlaeiakr.fsf@basil.nowhere.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 05 Aug 2009 13:07:24 -0700
In-Reply-To: <87zlaeiakr.fsf@basil.nowhere.org> (Andi Kleen's message of "Wed\, 05 Aug 2009 16\:45\:08 +0200")
Message-ID: <m163d2t477.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: andi@firstfloor.org, avorontsov@ru.mvista.com, mingo@elte.hu, akpm@linux-foundation.org, nhorman@redhat.com, linux-ia64@vger.kernel.org, tony.luck@intel.com, linux-kernel@vger.kernel.org, amwang@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0229]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [Patch 1/7] x86: add CONFIG_KEXEC_AUTO_RESERVE
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Amerigo Wang <amwang@redhat.com> writes:
>
>> Introduce a new config option KEXEC_AUTO_RESERVE for x86.
>
> The description of the feature belongs in the changelog.
>
> I like the basic idea, but:
>
>> +config KEXEC_AUTO_RESERVE
>> +	bool "automatically reserve memory for kexec kernel"
>> +	depends on KEXEC
>> +	default y
>> +	---help---
>> +	  Automatically reserve memory for a kexec kernel, so that you don't
>> +	  need to specify numbers for the "crashkernel=X@Y" boot option,
>> +	  instead you can use "crashkernel=auto".
>> +	  On x86, 128M is reserved.
>
> The obvious problem is the hardcoded 128MB (and 128MB is very large
> for a crash kernel anyways)
>
> More useful would seem a crashkernel=size@auto

That is actually called "crashkernel=size" and we have had that for quite
a while.  Although some of the init scripts have problems.

Eric
