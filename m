Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab0BMUMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 15:12:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328Ab0BMUMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 15:12:30 -0500
Date: Sat, 13 Feb 2010 12:11:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 25/35] move round_up/down to kernel.h
Message-Id: <20100213121139.b2589bce.akpm@linux-foundation.org>
In-Reply-To: <4B7702FE.7060407@zytor.com>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
	<1265793639-15071-26-git-send-email-yinghai@kernel.org>
	<1266086980.16721.837.camel@Joe-Laptop.home>
	<4B7702FE.7060407@zytor.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010 11:52:30 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 02/13/2010 10:49 AM, Joe Perches wrote:
> > 
> > Having both roundup and round_up in kernel.h is a 
> > near guarantee for a future incorrect use.
> > 
> > Can't you use a different name for this?
> > 
> 
> Welcome to last week's discussion.

Which seems to have been basically ignored.

> Both of these names already exist -- yes, a rename is probably in order
> but it should be a separate patchset.

More than a rename is certainly in order.

As Joe says, if we just chuck these things into kernel.h(!) as-is,
people will start using them and the muck gets deeper.

And it's not clear who will be shovelling that muck, and when.  We
haven't even worked out what needs to be done.


