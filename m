Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbYJVUEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbYJVUEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYJVUEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:04:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57958 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYJVUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:04:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: netdev <netdev@vger.kernel.org>, Dave Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@ftp.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Denis Lunev <den@openvz.org>,
       Linux Containers <containers@lists.linux-foundation.org>
References: <20081022152144.351965414@theryb.frec.bull.fr>
Date: Wed, 22 Oct 2008 12:59:29 -0700
In-Reply-To: <20081022152144.351965414@theryb.frec.bull.fr> (Benjamin Thery's
	message of "Wed, 22 Oct 2008 17:21:44 +0200")
Message-ID: <m1d4hso0ym.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Benjamin Thery <benjamin.thery@bull.net>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1083]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 0/4][RFC] netns: sysfs: add a netns suffix to net device sysfs entries
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Thery <benjamin.thery@bull.net> writes:

> Support for network namespaces in mainline is pretty complete for
> some time now, but there is still this issue with sysfs that prevents 
> more people to use it easily.

Ben your patchset is completely inappropriate.

Temporarily adding elements to the ABI that we intend to remove
is not a proper solution to this problem.

That user space visible ida you add is a namespace identifier that breaks
nested containers and migration.  It is very very very wrong.

Eric

