Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbXKIUHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbXKIUHB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 15:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXKIUGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 15:06:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbXKIUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 15:06:53 -0500
Date: Fri, 9 Nov 2007 12:06:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: eranian@hpl.hp.com, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-Id: <20071109120627.60ec9ab4.akpm@linux-foundation.org>
In-Reply-To: <20071107003454.GA13374@kroah.com>
References: <20071107003454.GA13374@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 16:34:54 -0800
Greg KH <greg@kroah.com> wrote:

> Here's a patch against my current tree that gets the perfmon code
> building and hopefully working.

Unfortunately I still haven't merged perfmon due to recently-occurring
minor conflicts with Tony's ia64 tree and more major recently-occurring
conflicts with the x86 tree.

There's not really a lot which Stephane can practically do about this -
normally I'll just get down and fix stuff like this up.  But the impression
I get from various people is that the perfmon tree in its present form
would not be a popular merge.

The impression which people have (and I admit to sharing it) is that
there's just too much stuff in there and it might not all be justifiable. 
But I suspect that people have largely forgotten what is in there, and why
it is in there.

We really need to get this ball rolling, and that will require a sustained
effort from more people than just Stephane.  I suppose as a starting point
we could yet again review the existing patches, please.  People will mainly
concentrate upon the changelogging to understand which features are being
proposed and why, so that submission should describe these things pretty
carefully: what are the features and why do we need each of them.

tia.
