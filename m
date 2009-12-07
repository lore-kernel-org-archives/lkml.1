Return-Path: <linux-kernel-owner+w=401wt.eu-S935614AbZLGW1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935614AbZLGW1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934416AbZLGW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:27:13 -0500
Received: from tundra.namei.org ([65.99.196.166]:45293 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbZLGW1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:27:12 -0500
Date: Tue, 8 Dec 2009 09:26:54 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Amerigo Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] selinux: remove a useless return
In-Reply-To: <20091203085127.4370.1737.sendpatchset@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.0912080925340.21327@tundra.namei.org>
References: <20091203085127.4370.1737.sendpatchset@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Amerigo Wang wrote:

> The last return is unreachable, remove the 'return'
> in default, let it fall through.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@parisplace.org>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

with a fixup for the problem reported by Dan Carpenter.

You should not send out patches without testing them, even when following 
the advice of the person you're sending them to :-)


-- 
James Morris
<jmorris@namei.org>
