Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbZATBlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbZATBlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZATBlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:41:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2141 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZATBlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:41:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=GI+GQUYe/HI05NGKcs/6SqtI79VOuPBYp/AKnzgV0Jc3spkzkYpH9I7E8+vX7qLrL
	wkHbQrnZvhU259Epf+msA==
MIME-Version: 1.0
In-Reply-To: <20090116120001.f37e1895.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090116120001.f37e1895.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 19 Jan 2009 17:41:02 -0800
Message-ID: <6599ad830901191741j4668f529s97ee6e896b0c011d@mail.gmail.com>
Subject: Re: [PATCH 2/4] cgroup:add css_is_populated
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.148
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 7:00 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Li-san, If you don't like this, could you give me an idea for
> "How to check cgroup is fully ready or not" ?
>
> BTW, why "we have a half filled direcotory - oh well" is allowed....

That's pretty much inherited from the original cpusets code. It
probably should be cleaned up, but unless the system is totally hosed
it seems pretty unlikely for creation of a few dentries to fail.

Paul
