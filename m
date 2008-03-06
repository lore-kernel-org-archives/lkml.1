Return-Path: <linux-kernel-owner+w=401wt.eu-S1765843AbYCFNdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765843AbYCFNdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYCFNdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:33:33 -0500
Received: from namei.org ([69.55.235.186]:37175 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756058AbYCFNdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:33:32 -0500
Date: Fri, 7 Mar 2008 00:31:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Paul Moore <paul.moore@hp.com>, Alexey Dobriyan <adobriyan@sw.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH -v8 -rc3] Security: Introduce security= boot parameter
In-Reply-To: <20080306121913.GA8506@ubuntu>
Message-ID: <Xine.LNX.4.64.0803070025440.16767@us.intercode.com.au>
References: <20080306121913.GA8506@ubuntu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008, Ahmed S. Darwish wrote:

>     Handle Andrew's concerns:
>     - Use __init and __initdata in appropriate places.
>     - Do not rely upon dummy_ops layout, use C99 initializations.
>     - Use DEFINE_SPINLOCK instead of dynamic initialization.

The spinlock is not needed now, if security_module_enable() can only be 
called during boot via an initcall.


- James
-- 
James Morris
<jmorris@namei.org>
