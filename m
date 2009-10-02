Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZJBDBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZJBDBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 23:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZJBDBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 23:01:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34430 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbZJBDBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 23:01:06 -0400
To: akataria@vmware.com
Cc: Arjan van de Ven <arjan@infradead.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization\@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>
	<20090919224430.GB9567@kroah.com>
	<1253419185.3253.21.camel@ank32.eng.vmware.com>
	<20090920074247.GA5733@elte.hu>
	<1253647845.10565.20.camel@ank32.eng.vmware.com>
	<4AB9CE66.1030504@redhat.com>
	<1254185107.13456.32.camel@ank32.eng.vmware.com>
	<20090929100831.18ece319@infradead.org>
	<1254242989.7803.11.camel@ank32.eng.vmware.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 01 Oct 2009 20:00:51 -0700
In-Reply-To: <1254242989.7803.11.camel@ank32.eng.vmware.com> (Alok Kataria's message of "Tue\, 29 Sep 2009 09\:49\:49 -0700")
Message-ID: <m1y6nuxzx8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;akataria@vmware.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Paravirtualization on VMware's Platform [VMI].
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria <akataria@vmware.com> writes:

> On Tue, 2009-09-29 at 01:08 -0700, Arjan van de Ven wrote:
>> > For now I have just added some text in the feature-removal file and
>> > disabled VMI by default in the Kconfig, the reason that needs to be
>> > done is because "Live Migration" of a VMI enabled VM to future
>> > products which don't support VMI will not work, so its important that
>> > newer distros keep this disabled, if they want seamless migration
>> > that is.
>> 
>> btw the "default" in KConfig tends to be totally ignored by distro
>> kernel maintainers... please don't assume that just because some default
>> is set in KConfig it has ANY impact on what shows up in distributions.
>
> So, are you saying that we should be doing something else along with
> toggling it off in the Kconfig ? 
> We have already informed most of the distro folks about this deprecation
> so I think we should be okay there, but if there is something else that
> should be done, do let me know.

Perhaps log a message when it is first used?

I do that for sysctl right now.

Eric
