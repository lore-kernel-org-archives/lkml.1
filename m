Return-Path: <linux-kernel-owner+w=401wt.eu-S933671AbXCFAht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671AbXCFAht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933672AbXCFAht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:37:49 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:44668 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933671AbXCFAhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:37:47 -0500
Date: Mon, 5 Mar 2007 19:37:43 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Eric Paris <eparis@parisplace.org>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Venkat Yekkirala <vyekkirala@trustedcs.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH] xfrm audit hook misplaced in pfkey_delete and xfrm_del_sa
In-Reply-To: <1172866536.31047.32.camel@localhost.localdomain>
Message-ID: <Line.LNX.4.64.0703051937320.17389@d.namei>
References: <1172866536.31047.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Eric Paris wrote:

> Inside pfkey_delete and xfrm_del_sa the audit hooks were not called if
> there was any permission/security failures in attempting to do the del
> operation (such as permission denied from security_xfrm_state_delete).
> This patch moves the audit hook to the exit path such that all failures
> (and successes) will actually get audited.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
