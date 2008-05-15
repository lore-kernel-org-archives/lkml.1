Return-Path: <linux-kernel-owner+w=401wt.eu-S1763621AbYEOSul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763621AbYEOSul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYEOSuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:50:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52292 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbYEOSuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:50:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	<20080514205204.GJ30469@redhat.com>
	<1210830110.23707.141.camel@caritas-dev.intel.com>
Date: Thu, 15 May 2008 11:42:03 -0700
In-Reply-To: <1210830110.23707.141.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Thu, 15 May 2008 13:41:50 +0800")
Message-ID: <m18wybs938.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Huang, Ying" <ying.huang@intel.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0053]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH -mm] kexec jump -v9
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> Hi, Vivek,
>
> On Wed, 2008-05-14 at 16:52 -0400, Vivek Goyal wrote:
> [...]
>> Ok, I have done some testing on this patch. Currently I have just
>> tested switching back and forth between two kernels and it is working for
>> me.
>> 
>> Just that I had to put LAPIC and IOAPIC in legacy mode for it to work. Few
>> comments/questions are inline.
>
> It seems that for LAPIC and IOAPIC, there is
> lapic_suspend()/lapic_resume() and ioapic_suspend()/ioapic_resume(),
> which will be called before/after kexec jump through
> device_power_down()/device_power_up(). So, the mechanism for
> LAPIC/IOAPIC is there, we may need to check the corresponding
> implementation.

And if you start with the device shutdown path the code is already
there and working.

Eric
