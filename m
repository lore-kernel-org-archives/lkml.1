Return-Path: <linux-kernel-owner+w=401wt.eu-S932360AbZDJJF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbZDJJF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761677AbZDJJFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:05:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758456AbZDJJFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:05:10 -0400
Date: Fri, 10 Apr 2009 11:04:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/30] netns: extract net_create()
Message-ID: <20090410090404.GE17962@elte.hu>
References: <20090410023448.GH27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023448.GH27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -107,6 +107,7 @@ static inline struct net *copy_net_ns(unsigned long flags, struct net *net_ns)
>  extern struct list_head net_namespace_list;
>  
>  #ifdef CONFIG_NET_NS
> +struct net *net_create(void);
>  extern void __put_net(struct net *net);

Ditto.

	Ingo
