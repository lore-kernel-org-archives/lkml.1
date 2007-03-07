Return-Path: <linux-kernel-owner+w=401wt.eu-S965753AbXCGXo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965753AbXCGXo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965756AbXCGXo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:44:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37515
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965753AbXCGXoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:44:25 -0500
Date: Wed, 07 Mar 2007 15:44:24 -0800 (PST)
Message-Id: <20070307.154424.55724478.davem@davemloft.net>
To: eparis@parisplace.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jmorris@namei.org,
       vyekkirala@trustedcs.com, cxzhang@watson.ibm.com, sds@tycho.nsa.gov
Subject: Re: [PATCH] xfrm audit hook misplaced in pfkey_delete and
 xfrm_del_sa
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172866536.31047.32.camel@localhost.localdomain>
References: <1172866536.31047.32.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@parisplace.org>
Date: Fri, 02 Mar 2007 15:15:36 -0500

> Inside pfkey_delete and xfrm_del_sa the audit hooks were not called if
> there was any permission/security failures in attempting to do the del
> operation (such as permission denied from security_xfrm_state_delete).
> This patch moves the audit hook to the exit path such that all failures
> (and successes) will actually get audited.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Also applied, thanks a lot Eric.
