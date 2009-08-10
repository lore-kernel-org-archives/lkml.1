Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbZHJHgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbZHJHgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZHJHgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:36:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:52879 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbZHJHgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VtmgG3XYaazBTdJtAd75/RzKYxTWUx3EZ7+9WtA06iPsNKWicMmaYrKraCSoBZaADk
         noL3dPVfeK6xZ6YpIjI5G3kIC2+3JDXUebUvUs4keCv6/+pVXdt8VuVOKqz9rJacmPbb
         ScDU3ZYvFhhW1WigA6qivOwvx8QwcodwAA6N0=
Message-ID: <4A7FCE01.8080206@gmail.com>
Date: Mon, 10 Aug 2009 09:36:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.3 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jack Morgenstein <jackm@dev.mellanox.co.il>
CC: general@lists.openfabrics.org, Roland Dreier <rdreier@cisco.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ofa-general] Re: [PATCH 10/14] infiniband: use printk_once
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com> <1249847649-11631-11-git-send-email-marcin.slusarz@gmail.com> <adaocqo9sb4.fsf@cisco.com> <200908100936.26963.jackm@dev.mellanox.co.il>
In-Reply-To: <200908100936.26963.jackm@dev.mellanox.co.il>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2009 08:36 AM, Jack Morgenstein wrote:
> printk_once will print once ONLY if CONFIG_PRINTK is set in include/linux/autoconf.h
> (i.e., when the kernel is configured).  Otherwise, it gets defined to printk --
> and it will always print in this case.

Not true, in that case printk is defined as inlined 'return 0;'

> (see 2.6.30.xx kernel include file "include/linux/kernel.h", lines 235, 249, and 272).

See line 265 there.
