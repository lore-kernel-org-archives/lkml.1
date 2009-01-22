Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZAVCOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZAVCOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 21:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZAVCOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 21:14:01 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49574 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbZAVCOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 21:14:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=pMpKADQiLrPjOSbhMFgFBSGtJzh5pDciOMALcRrtmosEgDihksTLWw7AnZy+A4Bh3
	9VQAeUqUz62RqNNt/HuRQ==
MIME-Version: 1.0
In-Reply-To: <20090122110632.e5c4216c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090115192120.9956911b.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090115192712.33b533c3.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901191739t45c793afk2ceda8fc430121ce@mail.gmail.com>
	 <20090120110221.005e116c.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901191823q556faeeub28d02d39dda7396@mail.gmail.com>
	 <20090120115832.0881506c.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090120144337.82ed51d5.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901210136j9baf45ft4c86a93fec70827f@mail.gmail.com>
	 <20090121193436.c314ad7d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090122110632.e5c4216c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 21 Jan 2009 18:13:53 -0800
Message-ID: <6599ad830901211813v1256db8q36facac4f99f4837@mail.gmail.com>
Subject: Re: [PATCH 1.5/4] cgroup: delay populate css id
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
X-GMailtapped-By: 172.24.198.81
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 6:06 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> BTW, isn't it better to use rcu_assign_pointer to show "this pointer will be
> dereferenced from RCU-read-side" ?
>

Yes, I think using rcu_assign_pointer() is fine here.

Paul
