Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbXK0Vs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbXK0Vs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757379AbXK0VsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:48:19 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:43843 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755652AbXK0VsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:48:18 -0500
X-YMail-OSG: .NttYO4VM1mhfe7XiMJKL_UUMcD.j241rlF5Vy_MlXiVIrJW09VKethgqaVgtdvKMypaeEPQ4A--
X-RocketYMMF: rancidfat
Date: Tue, 27 Nov 2007 13:48:17 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] -mm (2.4.26-rc3-mm1) v2  Smack using capabilities 32 and 33
To: Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com
Cc: torvalds@linux-foundation.org, morgan@kernel.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20071127131632.808bf9f8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <611606.13033.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> > 
> > +		!__capable(current, CAP_MAC_ADMIN))
> > +		!__capable(current, CAP_MAC_ADMIN))
> 
> Is there any reason for not using plain old capable() here?

Nope. I'll clean that up.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
