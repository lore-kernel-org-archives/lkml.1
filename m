Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab0BDSOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:14:16 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53826 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803Ab0BDSOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=aMukWymFlPNSpVOS3WgdMm7i2sntYS9bkK7azDff0Gx2ebzREtwlzrjE0tvGsIr9+T
         Hhw/y9jCrflEuwnQ3TiHmj7m/700lchFi0T33EWBp+P8BkToG8wYP50tY1k1T5ya5Y91
         U3hFVF79fPtEUUppa+sTB+kLkkPM5WWzzMyO4=
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
In-Reply-To: <201002041850.31310.s.L-H@gmx.de>
References: <1265060041850@kroah.org> <201002032114.59960.s.L-H@gmx.de>
	 <1265282011.4204.12.camel@bigi>  <201002041850.31310.s.L-H@gmx.de>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 13:14:07 -0500
Message-Id: <1265307247.4651.2.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 18:50 +0100, Stefan Lippers-Hollmann wrote:
> sysctl table check failed

Can you look at your patched source include/linux/sysctl.h
and see whether you see the following lines:
----
        NET_IPV4_CONF_ARP_ACCEPT=21,
        NET_IPV4_CONF_ARP_NOTIFY=22,
        NET_IPV4_CONF_ACCEPT_LOCAL=23,
        NET_IPV4_CONF_SRC_VMARK=24,
        __NET_IPV4_CONF_MAX
---

I have a feeling you are missing NET_IPV4_CONF_ACCEPT_LOCAL

cheers,
jamal

