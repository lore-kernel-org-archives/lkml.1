Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZAIG2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZAIG2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZAIG2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:28:04 -0500
Received: from smtp-out.google.com ([216.239.45.13]:8120 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZAIG2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:28:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=nxHDPF+mTxfvc/VkdN68BZiAHAbMM60WpVUKEitMhcBgGm5POKZqnEAIEET1ciTC9
	qQC6U9IpDxd93Orp89uTg==
MIME-Version: 1.0
In-Reply-To: <20090109152422.82020371.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	 <4966EB5F.4010506@cn.fujitsu.com>
	 <20090109152422.82020371.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 8 Jan 2009 22:27:58 -0800
Message-ID: <6599ad830901082227x7995c1a6k9026b11551ab17cc@mail.gmail.com>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 10:24 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  - I wonder I can add some more debug support to debug cgroup like fault
>   injection. For example,
>
>   Add an create_may_fail file to debug cgroup.
>   # echo 1 > debug.create_may_fail

Yes, things like that could be potentially very useful for testing.

Paul
