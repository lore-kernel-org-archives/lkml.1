Return-Path: <linux-kernel-owner+w=401wt.eu-S935196AbXHAPVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935196AbXHAPVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935092AbXHAPV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:21:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33765 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934999AbXHAPV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:21:26 -0400
Subject: Re: [PATCH] RT: Add priority-queuing and priority-inheritance to
	workqueue infrastructure
From: Gregory Haskins <ghaskins@novell.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1185981025.2636.102.camel@imap.mvista.com>
References: <20070801002407.4973.54778.stgit@novell1.haskins.net>
	 <1185940340.2636.97.camel@imap.mvista.com>
	 <1185969554.9513.106.camel@ghaskins-t60p.haskins.net>
	 <1185981025.2636.102.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 11:19:45 -0400
Message-Id: <1185981585.9513.119.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 08:10 -0700, Daniel Walker wrote:

> 
> rt_mutex_setprio() is just a function. It was also designed specifically
> for PI , so it seems fairly sane to use it in other PI type
> situations ..
> 

Yes.  It is designed for PI and I wasn't suggesting you shouldn't use
the logic itself.  What I was suggesting is that dealing with an API
that has "rt_mutex" in it for something that has nothing to do with
rt_mutexes is, well...

All I was suggesting is that we break out the PI subsystem from rt_mutex
code so its an independent PI API and have the rt_mutex subsystem become
a user.   That's a far cleaner way to do it, IMHO.

-Greg



