Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbZAJAYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbZAJAYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZAJAYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:24:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:49519 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZAJAX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:23:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=ClB3fnqEjvy/oXEnqocbmGDzmy8G6DHPqlknnOYIatjP8ChbHfIcueNYJxAoPbIFM
	fUJHAuxgEqvXGp3vNOqZQ==
MIME-Version: 1.0
In-Reply-To: <20090108182817.2c393351.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090108182556.621e3ee6.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090108182817.2c393351.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 9 Jan 2009 16:23:53 -0800
Message-ID: <6599ad830901091623i2c3f6ce1ma88c845074b7c013@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/4] cgroup: support per cgroup subsys state ID (CSS 
	ID)
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.148
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 1:28 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> + *
> + * Looking up and scanning function should be called under rcu_read_lock().
> + * Taking cgroup_mutex()/hierarchy_mutex() is not necessary for all calls.

Can you clarify here - do you mean "not necessary for any calls"
(calls to what?) or "not necessary for some calls"? I presume the
former.

Paul
