Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXCXWat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXCXWat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 18:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXCXWat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 18:30:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:20721 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbXCXWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 18:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QCUPgSakO3Dyr/o82p7FlmKLFlYpgGfTalBS6nXW6dhFCWPd1OUtmq0Ko/yc6tG32W+2fhiX9QKZ17mj7Cv6eZG1NlB8vA2iIQdiVGgdzYzxAsuwHeKoEwRbkCOcEb7TonX+KLVRWO2uAjN7VIsfueDBfMiuHuKSfxIg1UrngIc=
Message-ID: <3d8471ca0703241530x79149b20sfb146fd77188c342@mail.gmail.com>
Date: Sat, 24 Mar 2007 23:30:46 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: tglx@linutronix.de
Subject: Re: [PATCH] i386: Prevent early access to TSC to avoid crash on TSCless systems
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "john stultz" <johnstul@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1174773769.10840.450.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1174773769.10840.450.camel@localhost.localdomain>
X-Google-Sender-Auth: a540f6a24291e9f3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int tsc_enabled;

So, now we have tsc_disable, tsc_enabled and tsc_unstable.
I can understand the latter, but this lacks orthogonality IMHO.

-- 
Guillaume
