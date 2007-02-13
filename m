Return-Path: <linux-kernel-owner+w=401wt.eu-S965446AbXBMBCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446AbXBMBCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 20:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965443AbXBMBCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 20:02:30 -0500
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:52477 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965446AbXBMBC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 20:02:29 -0500
Date: Mon, 12 Feb 2007 20:02:27 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: David Miller <davem@davemloft.net>
cc: latten@austin.ibm.com, ce@ruault.com, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: [BUG] 2.6.20 Oopses in xfrm_audit_log
In-Reply-To: <20070212.134628.98748410.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0702122002030.30113@d.namei>
References: <200702121744.l1CHiUD2026684@faith.austin.ibm.com>
 <20070212.134628.98748410.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007, David Miller wrote:

> Thus, below is the patch I will use to fix this bug:
> 
> 1) Calling xfrm_audit_log() with a NULL object is a BUG()
> 2) Setting "result" based upon NULL'ness of the object makes no
>    sense, either set it to "1" in these cases or use an appropriate
>    error check.
> 
> How does this look to others?

Looks good to me.


-- 
James Morris
<jmorris@namei.org>
