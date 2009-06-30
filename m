Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZF3RP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZF3RP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZF3RPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:15:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36285 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZF3RPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:15:48 -0400
To: Gleb Natapov <gleb@redhat.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi\@redhat.com" <avi@redhat.com>
References: <20090630064515.GG20289@redhat.com>
	<86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
	<20090630155820.GC8122@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Jun 2009 10:15:48 -0700
In-Reply-To: <20090630155820.GC8122@redhat.com> (Gleb Natapov's message of "Tue\, 30 Jun 2009 18\:58\:20 +0300")
Message-ID: <m1my7p7id7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gleb@redhat.com, avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gleb Natapov <gleb@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> On Tue, Jun 30, 2009 at 12:18:19AM -0700, Yinghai Lu wrote:
>> how about kexec second kernel in KVM ?
>> 
>> x2apic_preenabled will be set in second kernel.
>> 
> By the way anybody knows why kexec does not use BIOS reset code
> (cmos 0xf offset) to jump into new kernel after hard reset?

What I said before plus the fact that kexec grew up on systems
that don't have a BIOS.  So the option of using that piece of
was not there.

Eric
