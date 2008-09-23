Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYIWSfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYIWSfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYIWSfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:35:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35436 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbYIWSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:35:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ftp.linux.org.uk>
References: <48D7AC44.6050208@bull.net> <20080922153455.GA6238@kroah.com>
	<48D8FC1E.6000601@bull.net>
Date: Tue, 23 Sep 2008 11:23:57 -0700
In-Reply-To: <48D8FC1E.6000601@bull.net> (Benjamin Thery's message of "Tue, 23
	Sep 2008 16:24:30 +0200")
Message-ID: <m1k5d2oh4y.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: benjamin.thery@bull.net, viro@ftp.linux.org.uk, serue@us.ibm.com, linux-kernel@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Benjamin Thery <benjamin.thery@bull.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0069]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: sysfs: tagged directories not merged completely yet
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery <benjamin.thery@bull.net> writes:
>
> Oh.
> It's a pity Al couldn't re-review them before. We've already lost a lot
> of time with this patchset and it's blocking easier testing of network
> namespaces (right now, with a mainline kernel, we have to disable sysfs
> to build network namespaces).

I am confident that we have a good base with these patches and the rest of
the work can be done incrementally on top of them if any issues turn up.

Al recent rework of sysctl has a very similar structure.

> Thanks anyway. It's a good step to have it in a tree.

Yes.  That should prevent other changes out there from surprising
us.

Eric


