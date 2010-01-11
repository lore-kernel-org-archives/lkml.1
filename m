Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389Ab0AKBH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0AKBH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040Ab0AKBH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:07:56 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55601 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab0AKBH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:07:56 -0500
To: michael@laptop.org
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, andi@firstfloor.org,
       david@lang.hm, socketcan@hartkopp.net, alan@lxorguk.ukuu.org.uk,
       herbert@gondor.apana.org.au, Valdis.Kletnieks@vt.edu, bdonlan@gmail.com,
       zbr@ioremap.net, cscott@cscott.net, jmorris@namei.org,
       ebiederm@xmission.com, bernie@codewiz.org, mrs@mythic-beasts.com,
       randy.dunlap@oracle.com, xiyou.wangcong@gmail.com,
       penguin-kernel@i-love.sakura.ne.jp, sam@synack.fr,
       casey@schaufler-ca.com, serue@us.ibm.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
References: <20100110215848.GA26609@elf.ucw.cz>
	<20100110224010.GA3825@heat>
In-Reply-To: <20100110224010.GA3825@heat>
Message-Id: <201001111007.EAG82373.VHFQSLFOFMOOJt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 11 Jan 2010 10:07:53 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone wrote:
> Examples of software that I want to be able to gain privileges normally include:
> 
>    rainbow, which requires privilege in order to add new accounts to the system
>    and in order to call setuid() but which does not require networking
>    privileges.

If the system is not using local files (i.e. /etc/passwd and /etc/shadow),
the process who wants to add new accounts to the system might need network
access (e.g. to LDAP server), doesn't it?
