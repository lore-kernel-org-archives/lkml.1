Return-Path: <linux-kernel-owner+w=401wt.eu-S1762719AbZATBwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719AbZATBwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZATBwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:52:44 -0500
Received: from smtp-out.google.com ([216.239.33.17]:2701 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbZATBwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:52:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=rBjo88m4h13MF6e9tkqsS12TP8j5FUuz0LBv+M+5EaByg6fMvVaQ+c9MhF7P0rdAT
	V7XE21oGt8bsM5hdnX+KQ==
MIME-Version: 1.0
In-Reply-To: <1232072445.7955.40.camel@localhost>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	 <20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
	 <1232072445.7955.40.camel@localhost>
Date: Mon, 19 Jan 2009 17:52:36 -0800
Message-ID: <6599ad830901191752o53926bdbve593301aeff7330f@mail.gmail.com>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Paul Menage <menage@google.com>
To: matthltc@us.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.73
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 6:20 PM, Matthew Helsley <matthltc@us.ibm.com> wrote:
>
>        My feeling is this should be a signal subsystem rather than a NOOP
> subsystem. Then, if users want the grouping for something besides
> signaling, it doesn't matter if they don't issue any signals via the
> signal.send file. Also, I think Paul's suggestion would be just as
> useful for a signal subsystem.

The signal subsystem is similar to the "no-op" subsystem in that
neither of them actually need any state - in principle, it could be
useful to attach a signal subsys to multiple mounted hierarchies, to
provide signal semantics for each of them.

Would it make sense to allow a class of subsystem that explicitly has
no state (or at least, has no state that has a global meaning on the
machine), so that it can be multiply-mounted?

Paul
