Return-Path: <linux-kernel-owner+w=401wt.eu-S1765138AbYEOVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765138AbYEOVBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762979AbYEOVAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:00:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33305 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762825AbYEOVAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:00:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
References: <Pine.LNX.4.44L0.0803221645190.27399-100000@netrider.rowland.org>
	<200803222229.45673.rjw@sisk.pl> <m1k5hwzf2z.fsf@frodo.ebiederm.org>
	<200805150147.24968.rjw@sisk.pl>
Date: Thu, 15 May 2008 13:55:29 -0700
In-Reply-To: <200805150147.24968.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Thu, 15 May 2008 01:47:23 +0200")
Message-ID: <m1fxsjp9ry.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0459]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Thursday, 15 of May 2008, Eric W. Biederman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> Just an added data partial point.  In the kexec case I have had not heard
>> anyone screaming to me that ACPI doesn't work after we switch kernels.
>
> You don't remove power from devices while doing that.

No.  It is the second half of S5.  When we go from the boot kernel
to the restored kernel I am talking about.

That path is exactly what happens successfully in the kexec case.
Transitioning from one kernel to another.

If that path works reliably in kexec then we are talking about
something that can be solved without respect to any specific
ACPI implementation.

Eric


