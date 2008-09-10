Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYIJXpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYIJXpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYIJXpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:45:04 -0400
Received: from postel.suug.ch ([194.88.212.233]:45399 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYIJXpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:45:03 -0400
Date: Thu, 11 Sep 2008 01:45:23 +0200
From: Thomas Graf <tgraf@suug.ch>
To: Paul Menage <menage@google.com>
Cc: Ranjit Manomohan <ranjitm@google.com>, davem@davemloft.net,
       akpm@linux-foundation.org, kaber@trash.net, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
Message-ID: <20080910234523.GK20815@postel.suug.ch>
References: <Pine.LNX.4.64.0809101040280.7050@ranjit.corp.google.com> <20080910220115.GH20815@postel.suug.ch> <166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com> <6599ad830809101604o71b2fb82k2aca1eb0fd8ab6d8@mail.gmail.com> <20080910232413.GJ20815@postel.suug.ch> <6599ad830809101631q51371f75w2ab9f73ef2414f90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830809101631q51371f75w2ab9f73ef2414f90@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Menage <menage@google.com> 2008-09-10 16:31
> Yes, for this particular case it doesn't work. But isn't it much more
> likely that the admin/user will know that web-browsers tend to trigger
> bulk data transfers and configure the system so that the web browser
> always starts in its own cgroup, rather than trying to jump on it
> after the fact?

That's argueable I guess. Likely or not, it doesn't make sense to
add such restrictions if not required, especially not when it is
trivial to just look at the cgroup of the task directly.

If the ingress case is of such importance, I'd propose to lookup
the classid via skb -> socket -> task -> classid.

Anyways, I think we've listed all the pros and cons of either approach.
