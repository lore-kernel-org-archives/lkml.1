Return-Path: <linux-kernel-owner+w=401wt.eu-S938345AbXHLTuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938345AbXHLTuy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 15:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbXHLTur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 15:50:47 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:48397 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964812AbXHLTup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 15:50:45 -0400
X-YMail-OSG: qj7euGQVM1mRJtSs1l03wtFiS7ycUKjI4rJI__Cetoqb.TkcOMlHUv354_OprASnODY_DA9w4A--
X-RocketYMMF: rancidfat
Date: Sun, 12 Aug 2007 12:50:44 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Jan Engelhardt <jengelh@computergmbh.de>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <Pine.LNX.4.64.0708121309530.28963@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <139264.28979.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:


> >> >+static int smack_task_movememory(struct task_struct *p)
> >> >+{
> >> >+	int rc;
> >> >+
> >> >+	rc = smk_curacc(smk_of_task(p), MAY_WRITE);
> >> >+	return rc;
> >> >+}
> >> 
> >> Uh...
> >> 
> >> {
> >> 	return smk_curacc(smk_of_task(p), MAY_WRITE);
> >> }
> >> 
> >> (also others)
> >
> >That was a little excessive, wasn't it?
> 
> How do you mean? I was just suggesting to collapse the three [four] lines
> into
> one, getting rid of the tempotemporaries in a lot of these functions,
> for example,

Sorry, I meant that my code was excessive, not your comment.
Your comment was fine and most welcome. I'm sorry that I was
unclear and sounded defensive.


Casey Schaufler
casey@schaufler-ca.com
