Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbXGDXBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbXGDXBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbXGDXA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:00:56 -0400
Received: from web36614.mail.mud.yahoo.com ([209.191.85.31]:35480 "HELO
	web36614.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754949AbXGDXAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:00:55 -0400
X-YMail-OSG: bX.Ar9oVM1nLK.yvJVV_cnTGmRUB4pSWb5owJiFpzrC4GV7Y1CDuDfPxa1LUOImLLX4pMrOF2g--
X-RocketYMMF: rancidfat
Date: Wed, 4 Jul 2007 16:00:54 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: implement-file-posix-capabilities.patch
To: Andrew Morgan <morgan@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <468C1157.70905@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <989837.80686.qm@web36614.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morgan <morgan@kernel.org> wrote:

> no one has yet actually
> given an example of where fE being richer than a simple binary helps
> anything. Until I see an example, I'm going to hold the position that
> this is needless "complexity".

The only counter to this argument is that you now have a different
structure on files than on processes. Not a major issue, but one 
structure to describe capability sets is less complex than two.
That way you can have one function to print a capset, regardless
of its coming off a file or a process.

Just a thought.


Casey Schaufler
casey@schaufler-ca.com
