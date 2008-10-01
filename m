Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbYJAXYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbYJAXYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYJAXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:24:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:50897 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbYJAXY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:24:27 -0400
Date: Thu, 2 Oct 2008 09:23:59 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: penguin-kernel@I-love.SAKURA.ne.jp, serue@us.ibm.com, haradats@gmail.com,
       k.takeda26@gmail.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: ptrace_attach() should use the target process's
 mutex
In-Reply-To: <20081001153823.9930.86648.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0810020923370.12513@tundra.namei.org>
References: <200810012000.CGG73421.FQOHtLOJFVMOSF@I-love.SAKURA.ne.jp> <20081001153823.9930.86648.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008, David Howells wrote:

> ptrace_attach() should use the target process's mutex when attaching to it,
> not the current (tracer) process's mutex.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds-subsys


-- 
James Morris
<jmorris@namei.org>
