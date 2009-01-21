Return-Path: <linux-kernel-owner+w=401wt.eu-S1760128AbZAUChF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128AbZAUChF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 21:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbZAUCgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 21:36:53 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36503 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788AbZAUCgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 21:36:53 -0500
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Matt Helsley <matthltc@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Containers <containers@lists.linux-foundation.org>
In-Reply-To: <20090120120728.9be81131.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	 <20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
	 <1232072445.7955.40.camel@localhost>
	 <6599ad830901191752o53926bdbve593301aeff7330f@mail.gmail.com>
	 <20090120120728.9be81131.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 18:36:50 -0800
Message-Id: <1232505410.15636.142.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 12:07 +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 19 Jan 2009 17:52:36 -0800
> Paul Menage <menage@google.com> wrote:

<snip>

> > Would it make sense to allow a class of subsystem that explicitly has
> > no state (or at least, has no state that has a global meaning on the
> > machine), so that it can be multiply-mounted?
> > 
> multilply-mounted means its own hierachy can be created per mount point ?

I suspect that's what Paul meant -- multiple, distinct instances of the
subsystem could be mounted.

> If so, signal subsystem can be used instead of noop.

Agreed.

Cheers,
	-Matt Helsley


