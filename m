Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXDXNvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXDXNvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 09:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXDXNvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 09:51:51 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:43276 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161151AbXDXNvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 09:51:51 -0400
X-YMail-OSG: cvRai_MVM1k1TOAAgd5Hen9pbre24_rLyZVnQeTNv0dBKs3WUwU77svD3uqWwNQFl5se.FqdvjK67m1Nze_l9LIkMc9LN1AH_JevIvSoJ2NOR.3Ydxw-
X-RocketYMMF: rancidfat
Date: Tue, 24 Apr 2007 06:51:50 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [ANNOUNCE] UidBind LSM 0.1
To: roberto@unbit.it, linux-kernel@vger.kernel.org
In-Reply-To: <1177318451.20613.8.camel@hagrid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <316971.67258.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Roberto De Ioris <roberto@unbit.it> wrote:

> Hi all,
> this is a very simple module that allows bind() to tcp/udp port (>=1024)
> only for the uids defined in a configfs tree.

Would you be so kind as to cross post to linux-security-module?
Methinks that you might get additional valuable feedback there.

> It is a first version, it only works for PF_INET sockets and makes no
> difference between tcp and udp (i am working on this)
> 
> For (little) more info see 
> 
> http://projects.unbit.it/uidbind/
> 
> Patch attached is for vanilla 2.6.20.7

It would be correct to return -EACCES rather than -EPERM in the
access denial case. EACCES indicates that an access control decision
failed, while EPERM indicates that use of a privileged operation
was attempted while not possessing appropriate privilege.



Casey Schaufler
casey@schaufler-ca.com
