Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbXAXUYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbXAXUYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbXAXUYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:24:20 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:28488 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035AbXAXUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:24:19 -0500
X-YMail-OSG: 6R7bRAUVM1l1HQtSpmD515WuymLZwYib8SUH8uK.huLEaUfpDLyNLtLPorXMPaRPTDO5PcAG1jSIcj_3TJLkf5UM_mhDiD9W2a4DFu2WfxCa92UUZVISdz03mNB7p0i6zHRSht2UveHO1hakCd.KZkk4o5jAxkia
X-RocketYMMF: rancidfat
Date: Wed, 24 Jan 2007 12:24:18 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Implement file posix capabilities
To: "Bill O'Donnell" <billodo@sgi.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Friedhoff <chris@friedhoff.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
In-Reply-To: <20070124163004.GA15979@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <239813.31714.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Bill O'Donnell <billodo@sgi.com> wrote:

> ... That said, can one expect, through
> the use of these enhanced capabilities,
> to be able to add some finer grain 
> capabilities based on a specific userid?

POSIX capabilities are explictly disjoint from
userids in the kernel, and this is by design.
You could provide limited capability sets to
users at the application layer.

> In Chris' ping example,
> the suid is removed from /bin/ping to restrict it to
> root, and a 
> capability added to allow any user to execute it. 
> Can that example
> be extended to make it so only a _particular_ user
> can execute it?

Give the file the capability and set an
ACL that allows only that user execute access.

> I realize with SELinux, one could achieve the goal,
> but as a stopgap,
> can capabilities be used to get there?

Certainly, as above.

> Thanks,
> Bill
> 
> -- 
> Bill O'Donnell
> SGI

Have a look in /etc/irix.cap on a Trix box
some time. I suspect there might be one in
your facility.



Casey Schaufler
casey@schaufler-ca.com
