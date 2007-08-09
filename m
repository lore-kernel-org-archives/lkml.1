Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbXHITqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbXHITqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbXHITp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:45:58 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41410 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXHITp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:45:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH 2/2] sysctl: remove CTL_UNNUMBERED
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
Date: Thu, 09 Aug 2007 13:44:48 -0600
In-Reply-To: <20070806124530.GD6634@localhost.sw.ru> (Alexey Dobriyan's
	message of "Mon, 6 Aug 2007 16:45:31 +0400")
Message-ID: <m1y7gka3wv.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@sw.ru> writes:

> I found why first version should be rejected, and, no, it is not
> documentation updates. Here is version 2:

I care about the documentation because it is the best thing
we have for enforcing sane sysctl table usage.

After looking at the problem.  While I can't remove  ctl_name
from the sysctl tables easily.  What I can do is check at
registration time if a sysctl table is sane, and print
an error message and fail to register that table if it has problems.

Once that is in place I will have no problems killing CTL_UNNUMBERED.

Eric
