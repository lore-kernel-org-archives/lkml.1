Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZIOBfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZIOBfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 21:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756482AbZIOBfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 21:35:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:33293 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584AbZIOBfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 21:35:33 -0400
Date: Tue, 15 Sep 2009 11:35:17 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] SELinux: inline selinux_is_enabled in
 !CONFIG_SECURITY_SELINUX
In-Reply-To: <20090915005948.12692.40854.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0909151134250.13708@tundra.namei.org>
References: <20090915005948.12692.40854.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Eric Paris wrote:

> Without this patch building a kernel emits millions of warning like:
> 
> include/linux/selinux.h:92: warning: ?selinux_is_enabled? defined but not used
> 
> When it is build without CONFIG_SECURITY_SELINUX.  This is harmless, but
> the function should be inlined, so it gets compiled out.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: James Morris <jmorris@namei.org>

Linus, I'll assume you'll want to apply this directly.


-- 
James Morris
<jmorris@namei.org>
