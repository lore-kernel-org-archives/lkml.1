Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZEKJVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZEKJVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbZEKJV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:21:29 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41115 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZEKJV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yFArAgetLjEkjLInIgQ8rdo1BQeTXu8E0lnQuNv6UxKSB/ZjGqVYrRTQAuX9KP6eGO
         QUQdh8QUmMLvTBxReFpLBSx2GNO2K4KcuEfW9qXdk75K5tdB9Weqx6lvu8nXJ/gYlpHQ
         EGSoVnlD0tIdam5kgo3jwVJA5lzYP8OvUervY=
Message-ID: <4A07EE1C.2010705@gmail.com>
Date: Mon, 11 May 2009 11:21:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, yanghy@cn.fujitsu.com, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dma-mapping: mark DMA_nBITS_MASK as deprecated fix
References: <20090510085618D.fujita.tomonori@lab.ntt.co.jp>	<1241939066-10178-1-git-send-email-jirislaby@gmail.com> <20090511113659U.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090511113659U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2009 04:36 AM, FUJITA Tomonori wrote:
> But I think that you need to resend a version of this patch against
> tip. We need this patch in linux-next to warn some new users of these
> deprecated macros.

It depends on Ingo if he doesn't mind to pick it up :).

Anyway I though we want to merge this upstream for 1-2 releases and then
wave and tell it goodbye to propagate not only to linux-next users. I
would resend the patch with an entry in features removal schedule in
that case. But it's up to you...
