Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbXCFAhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbXCFAhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933670AbXCFAhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:37:31 -0500
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:36918 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbXCFAh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:37:27 -0500
Date: Mon, 5 Mar 2007 19:37:23 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Eric Paris <eparis@parisplace.org>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Venkat Yekkirala <vyekkirala@trustedcs.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] Add xfrm policy change auditing to pfkey_spdget
In-Reply-To: <1172861484.31047.26.camel@localhost.localdomain>
Message-ID: <Line.LNX.4.64.0703051937110.17389@d.namei>
References: <1172861484.31047.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Eric Paris wrote:

> pfkey_spdget neither had an LSM security hook nor auditing for the
> removal of xfrm_policy structs.  The security hook was added when it was
> moved into xfrm_policy_byid instead of the callers to that function by
> my earlier patch and this patch adds the auditing hooks as well.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
