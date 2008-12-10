Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYLJSZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYLJSZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYLJSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:25:29 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYLJSZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:25:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	content-type:content-transfer-encoding;
	b=u0+uyY2ZOFJ9tN6Rk9Ictsy0DXEtTZ8rHOlJlRWIlpXGeqA85BxWlIioSxEzM+SoG
	5BnlkRu7X9/YMKtfGdjyA==
MIME-Version: 1.0
In-Reply-To: <20081210132559.GF25467@balbir.in.ibm.com>
References: <6599ad830812100240g5e549a5cqe29cbea736788865@mail.gmail.com>
	 <29741.10.75.179.61.1228908581.squirrel@webmail-b.css.fujitsu.com>
	 <20081210132559.GF25467@balbir.in.ibm.com>
Date: Wed, 10 Dec 2008 10:25:20 -0800
Message-ID: <6599ad830812101025s4a8eab08v214ccc95565c398e@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 5:25 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> Paul, I can't find those patches in -mm. I will try and dig them out
> from my mbox. I agree, we need a hierarchy_mutex, cgroup_mutex is
> becoming the next BKL.

It never actually went into -mm. I'll sync it with the latest tree and
try to send it out today.

Paul
