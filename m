Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYFJQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYFJQO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYFJQOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:14:50 -0400
Received: from sous-sol.org ([216.99.217.87]:58984 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbYFJQOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:14:49 -0400
Date: Tue, 10 Jun 2008 09:12:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some
	configs, e.g. CONFIG_SECURITY_SELINUX
Message-ID: <20080610161240.GW30402@sequoia.sous-sol.org>
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org> <484C5E84.2020307@kernel.org> <20080608163926.56f1be3d.akpm@linux-foundation.org> <20080609171741.GA13403@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609171741.GA13403@us.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serue@us.ibm.com) wrote:
> If we decide to get rid of dummy long-term, then it's far less
> distasteful to have it lie and claim the keepcaps worked in the
> meantime.

We should get rid of it ASAP.

> So for 2.6.26 we could have dummy lie, then plan to make capabilities
> the default for 2.6.27?

It is already lying, so this isn't too big a stretch.  I'd expect it not
to help since either capset will fail, or it would fail when it tried
to use the cap after dropping uid.

thanks,
-chris
