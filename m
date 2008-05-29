Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbYE2Eki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbYE2Eki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 00:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbYE2Ek3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 00:40:29 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59635 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbYE2Ek3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 00:40:29 -0400
Date: Wed, 28 May 2008 23:40:25 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org, maxk@qualcomm.com
Subject: Re: [PATCH] [sched] Move cpu masks from kernel/sched.c into
 kernel/cpu.c
Message-Id: <20080528234025.621bce6a.pj@sgi.com>
In-Reply-To: <1211926006-11559-1-git-send-email-maxk@qualcomm.com>
References: <1211926006-11559-1-git-send-email-maxk@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max,

Does this patch mean that some 2K to 3K bytes of kernel text
will be added to non-SMP systems, due to kernel/cpu.o moving
from CONFIG_SMP only to always being included?

If so, then I'd think that the folks who obsess with small
non-SMP kernels might not like this change.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
