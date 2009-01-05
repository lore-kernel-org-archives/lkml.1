Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZAEOx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZAEOx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZAEOvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:51:32 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:57561 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbZAEOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:51:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oLQiKsqQ+vuV04iypurpG8tE1Wfbz8n1qAIfIxqkViiR/QbRwLvNz+hCnlWe8Jk5pP
         ZFAxAZol9fWZRF608Y2XXfqa+6O1g/FUTt0+usBJR2aJYou4js+GGDsMlsOxXhHSFLep
         FLh1V1uzo8klN5sBfmglO7fB/yvF3VnETRhcg=
Message-ID: <49621E6E.2010809@gmail.com>
Date: Mon, 05 Jan 2009 15:51:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
References: <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca> <20090105092619.GA3699@cmpxchg.org> <20090105130836.GN496@one.firstfloor.org>
In-Reply-To: <20090105130836.GN496@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2009 02:08 PM, Andi Kleen wrote:
> +#define EARLY_BUG_ON(x) do { if (unlikely(!(x))) EARLY_BUG(); } while (0)

I think unintentionally inverted logic.

> +#define EARLY_BUG_ON(x) do {} while(0)

Shouldn't be x referenced here?
