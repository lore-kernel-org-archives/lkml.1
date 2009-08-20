Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZHTCmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZHTCmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZHTCmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:42:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58924 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbZHTCmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:42:21 -0400
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
	<4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>
	<4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>
	<4A864008.50907@schaufler-ca.com> <m1my61sjie.fsf@fess.ebiederm.org>
	<4A8A2616.8020809@schaufler-ca.com>
	<1250597660.3629.204.camel@moss-pluto.epoch.ncsc.mil>
	<4A8AB6B0.8010800@schaufler-ca.com>
	<1250605386.3629.236.camel@moss-pluto.epoch.ncsc.mil>
	<4A8B81A0.6070206@schaufler-ca.com>
	<1250683089.3629.268.camel@moss-pluto.epoch.ncsc.mil>
	<4A8C91D4.3070308@schaufler-ca.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 19 Aug 2009 19:41:41 -0700
In-Reply-To: <4A8C91D4.3070308@schaufler-ca.com> (Casey Schaufler's message of "Wed\, 19 Aug 2009 16\:59\:16 -0700")
Message-ID: <m1skfni4uy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: casey@schaufler-ca.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, jmorris@namei.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Security/sysfs: v2 - Enable security xattrs to be set on sysfs files, directories, and symlinks.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> So I still don't like the way it exposes LSM internal data to the
> file system code, but given how long it's taking for me to create
> a better solution I don't think that I can in all fairness say NAK
> to David Quigley's sysfs patch any longer. I withdraw my objection,
> while maintaining my reservations.

Until I see it wired up against another filesystem I retain my
objections.  When I asked he pretty much told me that it doesn't
generalize to other filesystems well and it is a sysfs special case.

The way sysctl and proc are wired as special cases into the lsm
has been a maintenance disaster so far, and I think it a very bad
idea to add yet another lsm special case, that supports only one
filesystem.

Eric
