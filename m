Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYBRFRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYBRFRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYBRFR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:17:27 -0500
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:23914 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751831AbYBRFR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:17:26 -0500
X-YMail-OSG: p5gO.7MVM1mxYb33HoPRoLWj6.NQ3.Hzo_yWnJdvmeIH0YQVmO8cGgxoFOKF1k9g5WlPRAmI1Q--
X-RocketYMMF: rancidfat
Date: Sun, 17 Feb 2008 21:17:25 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Possible problem in linux file posix capabilities
To: "Serge E. Hallyn" <serue@us.ibm.com>, charles.kirsch@internet.lu
Cc: serue@us.ibm.com, Andrew Morgan <morgan@kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Gerald Combs <gerald@wireshark.org>,
       Gilbert Ramirez <gram@alumni.rice.edu>, Guy Harris <guy@alum.mit.edu>
In-Reply-To: <20080217224851.GA9168@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <728865.70879.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> ....
> 
> Two quick fixes for you right now (apart from the one you've already
> got :)  would be
> 
> 	1. give wireshark cap_kill, by doing something like
> 
> 		capset cap_kill=ep /bin/wireshark
> 
> 	2. compile a kernel with SECURITY_FILE_CAPABILITIES=n
> 
> Andrew, this pretty much was bound to happen...  we need to figure out
> what our approach here should be.  My preference is still to allow
> signals when p->uid==current->uid so long as !SECURE_NOROOT.  Then as
> people start using secure_noroot process trees they at least must know
> what they're asking for.
> 
> An alternative stance is to accept these things as they come up and try
> to quickly work with the authors of such programs to work around it.  I
> suppose in a security sense that's the superior way :)  But it also
> seems likely to lead to most people choosing option 2 above and not
> bothering to fix the problem.

I probably just missed it when it went by, but do you have some
test cases for file capabilities lying about that I might use?

Thank you.


Casey Schaufler
casey@schaufler-ca.com
