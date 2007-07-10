Return-Path: <linux-kernel-owner+w=401wt.eu-S1762160AbXGJSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160AbXGJSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXGJSxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:53:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbXGJSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:53:39 -0400
Date: Tue, 10 Jul 2007 11:53:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-Id: <20070710115319.0bdaff34.akpm@linux-foundation.org>
In-Reply-To: <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710105240.GA20914@linux.vnet.ibm.com>
	<6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:34:38 -0700
"Paul Menage" <menage@google.com> wrote:

> Andrew, how about we merge enough of the container framework to
> support CFS? Bits we could leave out for now include container_clone()
> support and the nsproxy subsystem, fork/exit callback hooks, and
> possibly leave cpusets alone for now (which would also mean we could
> skip the automatic release-agent stuff). I'm in Tokyo for the Linux
> Foundation Japan symposium right now, but I should be able to get the
> new patchset to you for Friday afternoon.

mm..  Given that you propose leaving bits out for the 2.6.23 merge, and
that changes are still pending and that nothing will _use_ the framework in
2.6.23 I'd be inclined to err on the side of caution and hold it all back
from 2.6.23.

This has the advantage that the merge will happen after the kernel-summit
containers discussion which I suspect will be an important point in the
life of this project...
