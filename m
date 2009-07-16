Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbZGPRPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbZGPRPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbZGPRPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:15:40 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59472 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbZGPRPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:15:39 -0400
Date: Thu, 16 Jul 2009 22:45:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dan Malek <dan@embeddedalley.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
Message-ID: <20090716171530.GC3576@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830907131515h3c9622b5v309cf8f13d272bab@mail.gmail.com> <20090714100440.6283.A69D9226@jp.fujitsu.com> <9B7C6FE2-D946-4286-9537-C4A715997B89@embeddedalley.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <9B7C6FE2-D946-4286-9537-C4A715997B89@embeddedalley.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Malek <dan@embeddedalley.com> [2009-07-14 12:13:32]:

> If you look at my presentation from the last ELC, you
> will see this patch is one small step of many to improve
> resource management.  This event notification discussion
> is important, but still just a tiny implementation detail in
> a bigger resource management scheme.  We need to
> make the small steps to make people aware of new features,
> write applications that utilize these features, and to
> perhaps discover something even better we aren't
> even considering.

Dan, if you are suggesting that we incrementally add features, I
completely agree with you, that way the code is reviewable and
maintainable. As we add features we need to

1. Look at reuse
2. Make sure the design is sane and will not prohibit further
development.

-- 
	Balbir
