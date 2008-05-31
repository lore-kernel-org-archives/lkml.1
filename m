Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYEaCbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYEaCbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 22:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYEaCa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 22:30:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33521 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYEaCa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 22:30:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: akpm@linuxfoundation.org, Chris Wright <chrisw@sous-sol.org>,
       stephen.hemminger@vyatta.com, adobriyan@gmail.com, morgan@kernel.org,
       xemul@openvz.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200805292349.m4TNneua029348@imap1.linux-foundation.org>
	<20080530161857.25e3fbc5@extreme> <m1wslbcjy9.fsf@frodo.ebiederm.org>
	<20080530191053.34182eaf@extreme>
Date: Fri, 30 May 2008 19:29:03 -0700
In-Reply-To: <20080530191053.34182eaf@extreme> (Stephen Hemminger's message of
	"Fri, 30 May 2008 19:10:53 -0700")
Message-ID: <m1hccfcikw.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Hemminger <shemminger@vyatta.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4447]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] sysctl: allow override of /proc/sys/net with CAP_NET_ADMIN
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com> writes:
> Unnecessary, it is a property of the root, and there is only one call to
> register_sysctl_root
> in the current code, and that registers the net_sysctl_root structure.

Oh right.  I was thinking it was a property of the ctl_table_header.
My mistake.

Then this is essentially the perfect place to put it.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Eric
