Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbXKLQDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbXKLQDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXKLQC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:02:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:29010 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbXKLQC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:02:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ArGVkWG+aleGv3ilvjbgN9+9d8MHuAyxAJ0U2WqwxNRpjXfB+uhTUtZ5d2gRkT9eUxJxuLymdZk1pBmym6eexafQMKAxEqtaZo2iXFKsSGMkFxIimEjoVvGQbs4LmpFD3bkruqne8NAkrap1OP2V+dZL/G7Kp30YNsCQQ8UWgis=
Message-ID: <47387928.5000409@gmail.com>
Date: Mon, 12 Nov 2007 17:02:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Yoav Artzi <yoavar@checkpoint.com>
CC: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
References: <473865BE.2070806@checkpoint.com> <47386DC9.4020905@gmail.com> <47387214.2010200@checkpoint.com> <20071112153908.GK9771@stusta.de> <47387810.3060503@checkpoint.com>
In-Reply-To: <47387810.3060503@checkpoint.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2007 04:58 PM, Yoav Artzi wrote:
> Looking at the source, I see:
> 
> #ifdef CONFIG_4KSTACKS
> #define THREAD_SIZE            (4096)
> #else
> #define THREAD_SIZE        (8192)
> #endif
> 
> 
> So if I configure the option CONFIG_4KSTACK, I will get a 4KB kernel
> stack. Am I missing something here?

But it's not configurable on x86_64, where the thread size defaults to 8k.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
