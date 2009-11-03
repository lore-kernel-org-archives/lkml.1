Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZKCCLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZKCCLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 21:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZKCCLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 21:11:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbZKCCLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 21:11:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=O8RTjESOmSfrPoTNNSo7lppbn9TUeNSS/eMf1MTXyQK8aiCbxUU0Jq7XV7TRD+ICq
	iAigI02N/t6awoLtk47Yg==
MIME-Version: 1.0
In-Reply-To: <4AEF8F7E.1000007@cn.fujitsu.com>
References: <20091102212825.GA13692@andrew.cmu.edu>
	 <4AEF8F7E.1000007@cn.fujitsu.com>
Date: Mon, 2 Nov 2009 18:11:33 -0800
Message-ID: <6599ad830911021811n7ccf7a70y6939ac581381c22f@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] cgroups: support for module-loadable subsystems
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: bblum@andrew.cmu.edu, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 6:03 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> I doubt the value of module-loadable subsystems. A cgroup subsystem
> is usually a kernel resource controller, and normally it needs to
> add some hooks in some in-kernel structures and functions, which
> makes it impossible to be a module.

Not true - as the classifier example shows, if there's already a
framework that supports hooking loadable modules into some kernel
system, a resource controller can be a module.

>
> In fact, net_cls is the only subsystem that can be a module, and
> make it a module doesn't seem to have real benefit?

Wouldn't it be just as useful as any other module-loadable classifier,
of which there are quite a few?

It's true that net_cls is currently the only subsystem that makes
sense to use as a module, but its existence shows that the concept
isn't too outlandish.

Paul
