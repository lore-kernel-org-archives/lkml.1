Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbXCEIwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbXCEIwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 03:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXCEIwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 03:52:37 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:35395 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbXCEIwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 03:52:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VwhKsSHyuIqDb6Mz3Ws3Z/WtjAQcltDljgRvsk42qAoin64kxWIfkQ/2laszRI+3We9mc91a8OW2KBFa0lot6ZwP2wLx7jiG+3fsIRVMrtb4JtW4pTBBODKlOhHCoBiT/7ZRLrHKj9D/CLjJyoVWjPGaofzAYeARzPaxLLWd/zo=
Message-ID: <29c147bd0703050052x7c8dca4esfc51b66c67b01cb1@mail.gmail.com>
Date: Mon, 5 Mar 2007 09:52:34 +0100
From: "Lorenzo Milesi" <lorenzo.milesi@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: Problem with skbuff.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070305.004436.41635733.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <29c147bd0703050032k71a06603p89d541071be5d656@mail.gmail.com>
	 <20070305.004436.41635733.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The fix for that bug was put into the kernel long before
> 2.6.20, so 2.6.20 all by itself should work just fine.

That patch applies "fine" to 2.6.20.1:

linux-2.6.20.1 # patch -p1 --dry-run < /home/maxxer/kerpatch.txt
patching file net/ipv6/ndisc.c
Hunk #2 succeeded at 559 (offset 2 lines).
Hunk #3 succeeded at 638 (offset 4 lines).
Hunk #4 succeeded at 1390 (offset 7 lines).

If this is not the correct fix for that bug I have some other problem,
because this seems to have fixed for me! ;)

Thanks

Maxxer
