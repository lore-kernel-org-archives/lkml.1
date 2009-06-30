Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZF3Tn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZF3Tn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZF3Tnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:43:51 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59367 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZF3Tnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:43:50 -0400
To: Gleb Natapov <gleb@redhat.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi\@redhat.com" <avi@redhat.com>
References: <20090629132926.GB20289@redhat.com>
	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
	<m1eit1acxl.fsf@fess.ebiederm.org> <20090630190307.GE8122@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Jun 2009 12:43:47 -0700
In-Reply-To: <20090630190307.GE8122@redhat.com> (Gleb Natapov's message of "Tue\, 30 Jun 2009 22\:03\:07 +0300")
Message-ID: <m17hyt1p8s.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gleb@redhat.com, avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gleb Natapov <gleb@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> Considering that interrupt remapping is fairly new feature
> are you saying that hotplug (pci and cpu) on x86 is a horrible
> hack on Linux?

Just the current cpu hotplug path.

>> It is better than nothing but it certainly is not something
>> I would expect to work all of the time.
>> 
> Because of horrible code or non-complaint ioapic implementation out
> there? If later this is not a big issue for KVM.

Both.  And even in spec ioapics can't be made to work 100% reliably.

>> Interrupt remapping is the one case where we have hardware
>> that works according to spec and that works reasonably well.
>> 
> I am sure when there was only one ioapic implementation in existence
> it worked according to a spec (and if not spec was changed :)) Give
> interrupt remapping some time and than we will see how above statement
> holds.

What we need for cpu hotplug/unplug is on the tested path now.
That is a significant difference.

Eric
