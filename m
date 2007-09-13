Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbXIMPQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbXIMPQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756487AbXIMPQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:16:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:61662 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbXIMPQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lFek/0fatf6N6kBF4Gc+DVI4XkaeVXVG9Hu5yq8BEL7ccziSTnNwEyJ6vewhWKCDZ92fu0do6qDljQECb8xv6bER9/oBIiAUZQ5c/la40BTDXTu9gp6cIKEC/b9woqISiQOZyBjIy5Xps+4x4cgtX2ri0SNAbUaMkwcNK2IUNV4=
Message-ID: <46E953D7.5070305@gmail.com>
Date: Thu, 13 Sep 2007 17:14:31 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jon Ivar Rykkelid <jonry@pvv.org>
CC: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: sata_nv issues with MCP51 SATA controller
References: <46E8EABF.3060409@pvv.org> <46E94728.9050509@garzik.org> <46E951C6.1000403@pvv.org>
In-Reply-To: <46E951C6.1000403@pvv.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Ivar Rykkelid wrote:
> Thanks for the suggestion, but sata_nv is not built modular in my
> current kernel, so "no can do" at the moment
> (However, if some expert REALLY thinks this will fix things, I will
> CERTAINLY recompile and give it a go)

Passing "sata_nv.adma=0" as kernel boot parameter will do the trick.

-- 
tejun
