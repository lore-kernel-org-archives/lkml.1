Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYDWMLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYDWMLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYDWMLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:11:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42961 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbYDWMLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:11:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kdb@oss.sgi.com, vgoyal@redhat.com, kexec@lists.infradead.org,
       Keith Owens <kaos@ocs.com.au>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Randy Dunlap <rdunlap@xenotime.net>, greg@kroah.com, bwalle@suse.de,
       k-miyoshi@cb.jp.nec.com
References: <480DD85C.7060200@ah.jp.nec.com> <480F1987.9010501@ah.jp.nec.com>
Date: Wed, 23 Apr 2008 05:11:26 -0700
In-Reply-To: <480F1987.9010501@ah.jp.nec.com> (Takenori Nagano's message of
	"Wed, 23 Apr 2008 20:12:07 +0900")
Message-ID: <m18wz4srdd.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0056]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 3/3] Move crash_kexec() into panic_notifier, take4
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takenori Nagano <t-nagano@ah.jp.nec.com> writes:

> This patch moves crash_kexec() into panic_notifier. If you want to use it,
> you have to set config option DUMP_ON_PANIC_NOTIFIER to Y. Its default value
> is N. If you set DUMP_ON_PANIC_NOTIFIER to N, kdump has no difference before.

NAK.  This patch is broken and does not accomplish what it
sets out to accomplish.

Eric
