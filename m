Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbXKLPOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbXKLPOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXKLPOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:14:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:65045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbXKLPOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:14:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Dp5rNNN7stAQWuG+7Wl0F0Z+Cs03VSBJISGZ+nfwc83l1t/qUZM1D/UcZhT7EgB+M0NTMPcFT+Mh9aGIrmmu1Y+62MWA+ySTsVJsXYfA4kOo6PxfpTrvD5FP+uQXgLFRPBz3BHDUJXAtXkVgfY0Ez5IfGP3sXoNd3J9/slSmbZ0=
Message-ID: <47386DC9.4020905@gmail.com>
Date: Mon, 12 Nov 2007 16:14:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Yoav Artzi <yoavar@checkpoint.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
References: <473865BE.2070806@checkpoint.com>
In-Reply-To: <473865BE.2070806@checkpoint.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2007 03:39 PM, Yoav Artzi wrote:
> According to my knowledge the PAGE_SIZE on 32bit architectures in 4KB.
> Logically, the PAGE_SIZE on 64bit architectures should be 8KB. That's at
> least the way I understand it. However, looking at the kernel code of
> x86_64, I see the PAGE_SIZE is 4KB.

Yes, it stood unchanged, the only difference is 4-level page tables.

> Can anyone explain to me what am I missing here?

What led you to that it must be 8k?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
