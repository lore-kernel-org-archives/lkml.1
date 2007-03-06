Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbXCFINe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbXCFINe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXCFINe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:13:34 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:44688 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXCFINc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ryfj04QXk7JlFlhfgSPk/isrCjUMhQLoEGfIDT8uydK7G3Olm5nPdkP70yo/BWbEWfz/sQ4GSp+BC3JPoligznrkBjhTTxfbsXWKZQ3BcuxxjjaZagDbPKZr1rD/WPyEggjTIrLyUdOAZS2zBo2+dhi2omTmsMLSpfK27xNYURU=
Message-ID: <45ED22AB.4090901@gmail.com>
Date: Tue, 06 Mar 2007 17:13:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] libata: add missing PM callbacks
References: <20070302083001.GK20322@htj.dyndns.org> <45E8B3C8.2090009@garzik.org> <45E8E749.4030406@gmail.com> <20070306080509.GA2040@elf.ucw.cz>
In-Reply-To: <20070306080509.GA2040@elf.ucw.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Much complexity for little gain. Who is running _without_ CONFIG_PM
> these days?

Embedded people, I guess.  The problem here is that if we are gonna
support !CONFIG_PM configuration and try to reduce the kernel/module
images size for such case, we end up sprinkling #ifdef's all over huge
number of device drivers.

If we determine to drop !CONFIG_PM configuration, I'm happy with that
too but we need to determine something here.  Alternatives...

1. drop !CONFIG_PM configuration
2. continue to sprinkle #ifdef's over device drivers
3. find out prettier way to mark PM functions

-- 
tejun
