Return-Path: <linux-kernel-owner+w=401wt.eu-S1765512AbXJZWfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765512AbXJZWfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbXJZWe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:34:56 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49707 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXJZWe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:34:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Kir Kolyshkin" <kir@openvz.org>
Cc: <containers@lists.osdl.org>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>
Subject: Re: [Devel] [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
References: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
Date: Fri, 26 Oct 2007 16:34:28 -0600
In-Reply-To: <CBC546DD07068244AEC110EFEDA58B7235893F@excite.int.sw-soft.com>
	(Kir Kolyshkin's message of "Fri, 26 Oct 2007 16:58:32 -0400")
Message-ID: <m1abq5y07f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Kir Kolyshkin" <kir@swsoft.com> writes:

> Speaking of this particular patch -- I don't understand how you fix
> "innumerable little bugs" by providing stubs instead of real functions.

I think it would be a disaster to use pid namespaces as currently
implemented 2.6.24-rc1 in a production environment.

There are lots of little bugs and I am certain know one knows what
they are all right now.

Therefore not creating more then the initial pid namespace in a
production environment sounds like the responsible thing to do for
2.6.24.

This patch enables people to guarantee they don't run software
that will create additional pid namespaces and expose them to
the bugs we have not yet found, and it says look out.  Don't
mess with this unless you know what you are doing.

That message of Look out be careful is what I really care
about sending to users of the kernel. 

The best way I know to do that is to mark the feature
(EXPERIMENTAL) and have a config option for the feature
that depends on CONFIG_EXPERIMENTAL.

Eric
