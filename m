Return-Path: <linux-kernel-owner+w=401wt.eu-S965790AbXCLMgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965790AbXCLMgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 08:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965789AbXCLMgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 08:36:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:4914 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965790AbXCLMgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 08:36:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=lCVOJq2YQQ+qD3zyGNQC1mx+YDfcfyzVL7jvCOsfAHQMy64H0mHyZP9J7NrNoFj6b1TZuIGWu71Qe4ZbAOGx+YXebISsYuGs8GNPI/Hcp04WuvNMzO8G5NC9TAVfEgZsQpLGcIXJLwKUTM7Krp8A1JcQko3pclbzXAze6iY8z3Y=
Message-ID: <84144f020703120536l3967dc76o6a130edc79762350@mail.gmail.com>
Date: Mon, 12 Mar 2007 14:36:46 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jarek Poplawski" <jarkao2@o2.pl>
Subject: Re: [PATCH] [REVISED] net/ipv4/multipath_wrandom.c: check kmalloc() return value.
Cc: "David Miller" <davem@davemloft.net>, amit2030@gmail.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org, netdev@vger.kernel.org
In-Reply-To: <20070312115137.GA3270@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070308.232908.92582631.davem@davemloft.net>
	 <20070312115137.GA3270@ff.dom.local>
X-Google-Sender-Auth: 0bddf1908569967d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Jarek Poplawski <jarkao2@o2.pl> wrote:
> So, maybe it's less evil to check those NULLs where possible and add
> some WARN_ONs here and there...

No, it's much better to oops rather than paper over a bug.
