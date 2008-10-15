Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYJOAuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYJOAuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYJOAuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:50:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41182 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYJOAuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:50:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080922153455.GA6238@kroah.com> <48D8FC1E.6000601@bull.net>
	<m1k5d2oh4y.fsf@frodo.ebiederm.org>
	<20081003101331.GH28946@ZenIV.linux.org.uk>
	<20081005053236.GA9472@kroah.com> <m1bpxwajyy.fsf@frodo.ebiederm.org>
	<20081007222726.GA9465@kroah.com> <48EBF21E.40709@kernel.org>
	<m1myh8rnf4.fsf@frodo.ebiederm.org> <48F45075.7000003@kernel.org>
	<20081014185320.GA24908@us.ibm.com>
Date: Tue, 14 Oct 2008 17:48:20 -0700
In-Reply-To: <20081014185320.GA24908@us.ibm.com> (Serge E. Hallyn's message of
	"Tue, 14 Oct 2008 13:53:20 -0500")
Message-ID: <m13aiyk7jf.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4842]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Again fuse doesn't address the *core* issue (sysfs needing a way to
> create files for multiple devicenames with same name).  But I believe
> Benjamin was looking into a minimal patch to fix that.  Benjamin,
> have you gotten anywhere with that?

I would love to hear a minimal strategy for that.

The only minimal strategy user space wise is to create multiple superblocks.
Anything else I an think of violates backwards compatibility.

Eric
