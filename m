Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbYLER0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbYLER0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYLER02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:26:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44482 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbYLER01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:26:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>
References: <20081203191706.GA16433@us.ibm.com>
	<20081203191733.GA16652@us.ibm.com>
	<m1ej0mr3o9.fsf@frodo.ebiederm.org>
	<20081205164552.GA16788@us.ibm.com>
Date: Fri, 05 Dec 2008 09:17:09 -0800
In-Reply-To: <20081205164552.GA16788@us.ibm.com> (Serge E. Hallyn's message of
	"Fri, 5 Dec 2008 10:45:52 -0600")
Message-ID: <m1k5aepmne.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
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
Subject: Re: [PATCH 2/2] user namespaces: require cap_set{ug}id for CLONE_NEWUSER
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

>> Personally the user namespace only becomes interesting when we
>> start to be able to move in the other direction and remove the
>> set of capabilities requires to create it.
>> 
>> Eric
>
> Agreed.  Now the thing is I don't think we need full userns
> support to get there.  We just need the targeted capabilities
> and the basic dummy fs support - that is, init_user_ns owns
> all vfsmounts, and anyone not in init_user_ns only gets
> user other access to files under those mounts.

Right.

> Of course complete support for targeted caps will in itself
> be a huge effort :)
>
> So my roadmap is: next address the per-user keyring, then
> the targeted caps.

Sounds good.

I expect this means we will pass through a period where the user
namespace is less useful than it is today.  But as it will be on
a much firmer foundation that is fine.

Eric

