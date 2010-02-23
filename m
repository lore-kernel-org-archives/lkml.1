Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0BWVpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:45:16 -0500
Received: from tundra.namei.org ([65.99.196.166]:59441 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab0BWVpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:45:13 -0500
Date: Wed, 24 Feb 2010 08:45:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: wzt.wzt@gmail.com
cc: sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Security: add static to security_ops and default_security_ops
 variable
In-Reply-To: <20100223151528.GA3393@localhost.localdomain>
Message-ID: <alpine.LRH.2.00.1002240844540.2315@tundra.namei.org>
References: <20100223151528.GA3393@localhost.localdomain>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, wzt.wzt@gmail.com wrote:

> Enhance the security framework to support resetting the active security
> module. This eliminates the need for direct use of the security_ops and
> default_security_ops variables outside of security.c, so make security_ops
> and default_security_ops static. Also remove the secondary_ops variable as
> a cleanup since there is no use for that. secondary_ops was originally used by
> SELinux to call the "secondary" security module (capability or dummy),
> but that was replaced by direct calls to capability and the only
> remaining use is to save and restore the original security ops pointer
> value if SELinux is disabled by early userspace based on /etc/selinux/config.
> Further, if we support this directly in the security framework, then we can
> just use &default_security_ops for this purpose since that is now available.
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
