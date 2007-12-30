Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbXL3A3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbXL3A3l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 19:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbXL3A3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 19:29:32 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:31877 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752405AbXL3A3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 19:29:31 -0500
X-YMail-OSG: eaX3Pf8VM1mjPB9.5Du3w8h0hfG_mhrMee6Qx.3z6vO3X8zIoeKOiNwGYwa8RH0_zCtN.kJ4rBC2I_Sf8qg5I1.p7ch2Uc0TB8O4rPlq.tlO9_W0hLk-
X-RocketYMMF: rancidfat
Date: Sat, 29 Dec 2007 16:29:29 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] security: remove security_sb_post_mountroot hook
To: "H. Peter Anvin" <hpa@zytor.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
In-Reply-To: <200712300020.lBU0KPcr010209@tazenda.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <139407.71031.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "H. Peter Anvin" <hpa@zytor.com> wrote:

> The security_sb_post_mountroot() hook is long-since obsolete, and is
> fundamentally broken: it is never invoked if someone uses initramfs.
> This is particularly damaging, because the existence of this hook has
> been used as motivation for not using initramfs.
> 
> Stephen Smalley confirmed on 2007-07-19 that this hook was originally
> used by SELinux but can now be safely removed:
> 
>      http://marc.info/?l=linux-kernel&m=118485683612916&w=2
> 
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@parisplace.org>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

It is also the case that Smack does not use this hook.
It can be removed as far as I'm concerned.



Casey Schaufler
casey@schaufler-ca.com
