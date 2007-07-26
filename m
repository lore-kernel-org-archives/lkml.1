Return-Path: <linux-kernel-owner+w=401wt.eu-S1765945AbXGZRZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765945AbXGZRZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761862AbXGZRZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:25:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58745 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761606AbXGZRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:25:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH] Remove CTL_UNNUMBERED
References: <20070726164518.GB16937@localhost.sw.ru>
Date: Thu, 26 Jul 2007 11:24:12 -0600
In-Reply-To: <20070726164518.GB16937@localhost.sw.ru> (Alexey Dobriyan's
	message of "Thu, 26 Jul 2007 20:45:18 +0400")
Message-ID: <m13azbulhf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@sw.ru> writes:

> CTL_UNNUMBERED is unneeded, because it expands to
>
> 	.ctl_name = 0
>
> The same effect can be achieved by skipping .ctl_name initialization,
> saving one line per sysctl.
>
> Update docs and headers telling people to not add CTL_ numbers and
> giving example.
>
> This is probably all we can do to stop the flow of new CTL_ numbers,
> because most of sysctls are copy-pasted. CTL_UNNUMBERED doesn't solve
> this problem at all.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

Nack.  Not unless you update the documentation and explanations
properly.

The important part is that we stop assigning binary numbers.  You
are removing part of the description of why we can not assign bianry
numbers and how that is important.

CTL_UNNUMBERED may be an irritant to you but as for actually using the
code I have look and it is about 6 of 1 half dozen of the other.

Eric
