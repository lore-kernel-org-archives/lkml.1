Return-Path: <linux-kernel-owner+w=401wt.eu-S937415AbXHPDWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937415AbXHPDWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXHPDWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:22:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:61796 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXHPDWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:22:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B2zjmAW8PdXaWUjzCJ26ccaznLoLZZc8VftklVkX8vjBQ7dYc1+6AOo2yjNrhz3QCBJTweiV0Fx10ADMe58yCu5YRnIZH6a3mVMXMeTd0clDxD1hrawg/a3f2WZyEzIgfT221s5BFG/Oh023A5ZNoIQUGna29tRcrwcZiSlMpks=
Message-ID: <7d1d9c250708152022s3c21be16x488a4f9705cd3b3d@mail.gmail.com>
Date: Wed, 15 Aug 2007 23:22:36 -0400
From: "Paul Gortmaker" <paul.gortmaker@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] remove Documentation/networking/net-modules.txt
Cc: "Andrew Morton" <akpm@linux-foundation.org>, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070814212604.GW18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070814212604.GW18945@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/07, Adrian Bunk <bunk@kernel.org> wrote:
> According to git, the only one who touched this file during the last
> 5 years was me when removing drivers...
>
> modinfo offers less ancient information.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>

Fine by me for any of the old stuff I was responsible for...

Acked-by: Paul Gortmaker <paul.gortmaker@gmail.com>



> -
> -       8390 based Network Modules              (Paul Gortmaker, Nov 12, 1995)
> -       --------------------------
> -
> -(Includes: smc-ultra, ne, wd, 3c503, hp, hp-plus, e2100 and ac3200)
> -
> -The 8390 series of network drivers now support multiple card systems without
> -reloading the same module multiple times (memory efficient!) This is done by
> -specifying multiple comma separated values, such as:
> -
> -       insmod 3c503.o io=0x280,0x300,0x330,0x350  xcvr=0,1,0,1
> -
