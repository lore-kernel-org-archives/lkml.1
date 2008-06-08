Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYFHXkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYFHXkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 19:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYFHXkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 19:40:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732AbYFHXkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 19:40:36 -0400
Date: Sun, 8 Jun 2008 16:39:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Morgan <morgan@kernel.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some
 configs, e.g. CONFIG_SECURITY_SELINUX
Message-Id: <20080608163926.56f1be3d.akpm@linux-foundation.org>
In-Reply-To: <484C5E84.2020307@kernel.org>
References: <1212932321.4675.9.camel@earth>
	<484BF662.9070100@kernel.org>
	<20080608110630.08a45cc6.akpm@linux-foundation.org>
	<484C5E84.2020307@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jun 2008 15:34:44 -0700 Andrew Morgan <morgan@kernel.org> wrote:

> | On Sun, 08 Jun 2008 08:10:26 -0700 Andrew Morgan <morgan@kernel.org>
> wrote:
> |
> |> Nacked-by: Andrew G. Morgan <morgan@kernel.org>
> |>
> |> In a configuration in which you are not using capabilities, what is the
> |> "keep capabilities" operation supposed to do? Lie to you?
> |>
> |> http://bugzilla.kernel.org/show_bug.cgi?id=10748
> |
> | I totally agree with comment 11 there. Quite a number of people have
> already
> | hit this and more surely will.  How can we help them (and hence us)?
>
> What do people think about comment #8 from Stephen Smalley?:
> 
> The dummy module is generally in the untenable position of having to lie
> to userspace or break the existing capability-related system call
> interface.  It should just go away, and make capability the default
> module (w/ stubs for the rest of the LSM hooks as with dummy).  Then
> CONFIG_SECURITY=n will yield the same result as CONFIG_SECURITY=y w/o
> any further options.

(removed pgp crap, undid top-posting.  Your emails are very hard to reply to)

It's a fine comment, but I am not knowledgeable enough in this area to
say whether it's a desirable thing to do for 2.6.26.

I fear that nothing will happen, and we'll end up wasting a lot of
peoples' time sending hey-why-did-my-dhcp-break reports.

