Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0CHUoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:44:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60686 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab0CHUoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:44:01 -0500
Date: Mon, 8 Mar 2010 20:44:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, eparis@redhat.com,
       faith@redhat.com
Subject: Re: [PATCH] Kernel: Fix coding style in kernel/audit.c
Message-ID: <20100308204359.GN30031@ZenIV.linux.org.uk>
References: <20100308222742.GB17489@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308222742.GB17489@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 06:27:42AM +0800, wzt.wzt@gmail.com wrote:
> Fix coding style in kernel/audit.c
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

NACKed-by: Al Viro <viro@zeniv.linux.org.uk>
NACKed-because: get a life

>  static int audit_set_enabled(int state, uid_t loginuid, u32 sessionid, u32 sid)
>  {
>  	int rc;
> +
>  	if (state < AUDIT_OFF || state > AUDIT_LOCKED)
>  		return -EINVAL;
>  
>  	rc =  audit_do_config_change("audit_enabled", &audit_enabled, state,
>  				     loginuid, sessionid, sid);
> -
>  	if (!rc)
>  		audit_ever_enabled |= !!state;

Seriously, people, please stop that masturbation.
