Return-Path: <linux-kernel-owner+w=401wt.eu-S1760828AbYFETic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828AbYFETic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYFETiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:38:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbYFETiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:38:22 -0400
Date: Thu, 5 Jun 2008 12:37:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas Tuttle" <ttuttle@google.com>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] pagemap: Require reads of /proc/pid/pagemap to be
 multiples of 8 (v2 of series)
Message-Id: <20080605123732.98dc47fb.akpm@linux-foundation.org>
In-Reply-To: <4ca0a85e0806051138q2a6a6aeav941e46c67ee12bd0@mail.gmail.com>
References: <4ca0a85e0806051138q2a6a6aeav941e46c67ee12bd0@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 14:38:10 -0400
"Thomas Tuttle" <ttuttle@google.com> wrote:

> This matches the behavior of /proc/kpage{count,flags}, and simplifies
> the logic a bit.
> 
> I also changed out and end in struct pagemapread to be u64* instead of
> char*, which makes put_user work the way it was intended.  (Before, it
> was only copying the bottom byte of a pagemap entry, because the target
> of the copy was a char*.)

This one is for 2.6.25.x?

Is so, the maintainers are going to wonder why the heck we sent it to
them.  It does fix a bug, but it is far from clear what that bug is.

Can we have a better description please?

> Signed-off-by: Thomas Tuttle

Please include <ttuttle@google.com> in the signoffs.
