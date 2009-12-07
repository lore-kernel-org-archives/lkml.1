Return-Path: <linux-kernel-owner+w=401wt.eu-S934470AbZLGWLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470AbZLGWLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbZLGWLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:11:32 -0500
Received: from tundra.namei.org ([65.99.196.166]:58874 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757804AbZLGWLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:11:31 -0500
Date: Tue, 8 Dec 2009 09:11:32 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Julia Lawall <julia@diku.dk>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] security/selinux/ss: correct size computation
In-Reply-To: <Pine.LNX.4.64.0912061016310.20858@ask.diku.dk>
Message-ID: <alpine.LRH.2.00.0912080911130.21013@tundra.namei.org>
References: <Pine.LNX.4.64.0912061016310.20858@ask.diku.dk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Dec 2009, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The size argument to kcalloc should be the size of desired structure,
> not the pointer to it.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @expression@
> expression *x;
> @@
> 
> x =
>  <+...
> -sizeof(x)
> +sizeof(*x)
> ...+>// </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
