Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYGAHvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYGAHvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYGAHvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:51:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35178 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYGAHvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:51:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, Benjamin Thery <benjamin.thery@bull.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
References: <20080618170729.808539948@theryb.frec.bull.fr>
	<20080618170731.002784342@theryb.frec.bull.fr>
	<485F04E1.70204@gmail.com> <m1y74svtff.fsf@frodo.ebiederm.org>
	<486706C9.9040303@gmail.com> <m18wwmsqdv.fsf@frodo.ebiederm.org>
	<20080630214421.GA29605@us.ibm.com>
Date: Tue, 01 Jul 2008 00:50:04 -0700
In-Reply-To: <20080630214421.GA29605@us.ibm.com> (Serge E. Hallyn's message of
	"Mon, 30 Jun 2008 16:44:23 -0500")
Message-ID: <m1bq1iqc0j.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 06/11] sysfs: Implement sysfs tagged directory support.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Now that the iproute2 patch is upstream, this patchset really is the
> only thing keeping us from using network namespaces.  Given that the
> details of the tagging are trivially changeable with no abi changes, I'd
> personally much rather see the patches go in as is, with whatever new
> tagging patches Benjamin whips up, using ida or some new idea, being
> applied later if we feel the need.

My point exactly.  No one seems to contest the userspace semantics so
as long as we don't put ourselves into a real mess we should be fine.

Eric
