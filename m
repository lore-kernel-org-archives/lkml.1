Return-Path: <linux-kernel-owner+w=401wt.eu-S1763007AbXH3Vvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763007AbXH3Vvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761304AbXH3Vvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:51:46 -0400
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:30239 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760372AbXH3Vvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:51:45 -0400
X-YMail-OSG: EhC7awsVM1nDSkRjFwCv9_RoiEUY9Hp5_R0lBC2lmnn087q_MGOGgoAuhuyfPO94nQ--
X-RocketYMMF: rancidfat
Date: Thu, 30 Aug 2007 14:51:44 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version2 Smack: Simplified Mandatory Access Control Kernel
To: Jan Engelhardt <jengelh@computergmbh.de>,
       Thomas Bleher <ThomasBleher@gmx.de>
Cc: Casey Schaufler <casey@schaufler-ca.com>, torvalds@osdl.org, akpm@osdl.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708302059270.24730@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <167655.10399.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Aug 27 2007 23:59, Thomas Bleher wrote:
> 
> >> +       for (cp = data - 1; cp != NULL; cp = strchr(cp + 1, '\n')) {
> >> +               if (*++cp == '\0')
> >> +                       break;
> >> +               if (sscanf(cp, "%14s %30s\n", name, target) != 2) {
> >> +                       printk("%s:%d bad scan\n",
> >> +                               __func__, __LINE__);
> >
> >Leftover debugging printk? Otherwise, a level would be nice.
> 
> Or even pr_debug.
> 
> (pr_debug("%s...

I'm taking out the printk.

> >> +	static struct tree_descr smack_files[] = {
> 
> Hey, can we make this const, if it does not change at runtime?

simple_fill_super() is unhappy with a const.
 

Casey Schaufler
casey@schaufler-ca.com
