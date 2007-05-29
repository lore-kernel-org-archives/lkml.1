Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbXE2F46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbXE2F46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 01:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXE2F4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 01:56:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXE2F4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 01:56:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: "Albert Cahalan" <acahalan@gmail.com>, linux-kernel@vger.kernel.org,
       jengelh@linux01.gwdg.de, holt@sgi.com, oleg@tv-sign.ru
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
In-Reply-To: Eric W. Biederman's message of  Monday, 28 May 2007 22:53:36 -0600 <m1646c8c33.fsf@ebiederm.dsl.xmission.com>
X-Zippy-Says: My haircut is totally traditional!
Message-Id: <20070529055647.221251F8511@magilla.localdomain>
Date: Mon, 28 May 2007 22:56:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Having the kernel not reparent user processes to init is an interesting
> idea, especially when those processes have not existed.  I'm not
> certain that is POSIX complaint and otherwise backwards compatible.

It's hard to see how it would work.  There has to be some parent PID.  The
reason using 1 makes sense is that it is always there.  Anything >0 and not
the PID of some live process could be reused for a new process at some point.


Thanks,
Roland
