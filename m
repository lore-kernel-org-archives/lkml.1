Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547Ab0A0AOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0A0AOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673Ab0A0AOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:14:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37798 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0A0AOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:14:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Roman Jarosz" <kedgedev@gmail.com>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
Cc: kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
       "A Rojas" <nqn1976list@gmail.com>,
       "Hugh Dickins" <hugh.dickins@tiscali.co.uk>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric Anholt" <eric@anholt.net>,
       "Chris Wilson" <chris@chris-wilson.co.uk>
In-Reply-To: <op.u646z3e7asvm2a@kedge>
References: <20100126183412.6AC9.A69D9226@jp.fujitsu.com> <op.u646z3e7asvm2a@kedge>
Message-Id: <20100127091354.6ACF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 27 Jan 2010 09:14:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -	mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
> > -			     GFP_HIGHUSER |
> > -			     __GFP_COLD |
> > -			     __GFP_FS |
> > -			     __GFP_RECLAIMABLE |
> > -			     __GFP_NORETRY |
> > -			     __GFP_NOWARN |
> > -			     __GFP_NOMEMALLOC);
> > -
> >  	kref_init(&obj->refcount);
> >  	kref_init(&obj->handlecount);
> >  	obj->size = size;
> 
> I've applied this patch and I'm testing it right now.
> Btw. what this patch will do from user(my) point of view?

OOM Killer disappear :)




