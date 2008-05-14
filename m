Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbYENWlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbYENWlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYENWkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:40:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45862 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYENWkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:40:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
References: <Pine.LNX.4.44L0.0803221645190.27399-100000@netrider.rowland.org>
	<200803222229.45673.rjw@sisk.pl>
Date: Wed, 14 May 2008 15:38:28 -0700
In-Reply-To: <200803222229.45673.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sat, 22 Mar 2008 22:29:44 +0100")
Message-ID: <m1k5hwzf2z.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: "Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0153]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday, 22 of March 2008, Alan Stern wrote:

> The spec doesn't say much about that, so we'll need to carry out some
> experiments.

> Still, as far as I can figure out what the spec authors _might_ mean, I think
> that it would be inappropriate to restore the ACPI NVS area if S5 was entered
> on "power off".  The idea seems to be that the restoration of the ACPI NVS area
> should complement whatever has been preserved by the platform over the
> hibernation/resume cycle.

> IMO, if S5 was entered on "powe off", there are two possible ways to go.
> Either ACPI is initialized by the boot kernel, in which case the image kernel
> should not touch things like _WAK and similar, just throw away whatever
> ACPI-related state it got from the image and try to rebuild the ACPI-related
> data from scratch.  Or the boot kernel doesn't touch ACPI and the image kernel
> initializes it in the same way as during a fresh boot (that might be difficult,
> though).

Just an added data partial point.  In the kexec case I have had not heard
anyone screaming to me that ACPI doesn't work after we switch kernels.

So I expect shutting down ACPI and restarting it should work reliably
and that is easy to test as that is already implemented with kexec.

Eric
