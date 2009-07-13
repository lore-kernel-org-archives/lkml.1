Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZGMXjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZGMXjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 19:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZGMXju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 19:39:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZGMXju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 19:39:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=T+be+icGOaRqQY56I1YwTEydg0jno/ivXHkyr4tPV9AXgMfi9hOMmXLWqrY31Rm2x
	ugVxY7xMhdeZIxluso35w==
MIME-Version: 1.0
In-Reply-To: <4A4D6DC4.10708@cn.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com>
	 <4A4D6DC4.10708@cn.fujitsu.com>
Date: Mon, 13 Jul 2009 16:39:43 -0700
Message-ID: <6599ad830907131639l273dbe6bmee98e745dc440174@mail.gmail.com>
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 7:32 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> cgroup_set_super() is called with spinlock held, so we
> can't do kmalloc(GFP_KERNEL).

Good point. I'll have to go back to pre-allocating the root before
calling sget()

Paul
