Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYIKKfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYIKKfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYIKKfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:35:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60583 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYIKKfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:35:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: chucklever@gmail.com, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, linux-nfs@vger.kernel.org
References: <48C52B29.4020204@fr.ibm.com> <20080909124311.GA10053@us.ibm.com>
	<m18wu1nyon.fsf@frodo.ebiederm.org>
	<20080909152952.GA21207@us.ibm.com>
	<DE845309-1684-472A-8269-78AB3A2823A9@oracle.com>
	<m1fxo9mba5.fsf@frodo.ebiederm.org> <48C791F9.8090606@fr.ibm.com>
	<76bd70e30809100812r4a7fa71crfc7196350e3ed1cf@mail.gmail.com>
	<m1ej3rixbx.fsf@frodo.ebiederm.org> <48C8DEA0.9080905@fr.ibm.com>
Date: Thu, 11 Sep 2008 03:27:29 -0700
In-Reply-To: <48C8DEA0.9080905@fr.ibm.com> (Cedric Le Goater's message of
	"Thu, 11 Sep 2008 11:02:24 +0200")
Message-ID: <m1r67rgepa.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cedric Le Goater <clg@fr.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4248]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH] sunrpc: fix oops in rpc_create() when the mount namespace is unshared
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater <clg@fr.ibm.com> writes:

>> The conservative play is to always force use of the initial namespace
>> and to deny creation of mounts that would use different namespaces.  In part
>> because the initial version of the namespace always exists.  Which means
>> as relates to Cedrics initial patch we would still need to know which
>> mounts should cause us to use a different uts namespace so we can deny
>> them.
>
> I will send the initial patch which forces use of the initial namespace because
> it does fix a real oops. 
>
> Then, I should be able to find some time to work on improving the uts namespace
> checks when NFS mounts are done.

Thanks.
Eric
