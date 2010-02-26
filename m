Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164Ab0BZD40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 22:56:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:52206 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935141Ab0BZD4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 22:56:23 -0500
Date: Fri, 26 Feb 2010 14:56:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SELinux: Make selinux_kernel_create_files_as() shouldn't
 just always return 0
In-Reply-To: <20100226015616.24445.64210.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1002261455560.25099@tundra.namei.org>
References: <20100226015616.24445.64210.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010, David Howells wrote:

> Make selinux_kernel_create_files_as() return an error when it gets one, rather
> than unconditionally returning 0.
> 
> Without this, cachefiles doesn't return an error if the SELinux policy doesn't
> let it create files with the label of the directory at the base of the cache.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
