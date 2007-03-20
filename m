Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbXCTFEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbXCTFEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 01:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933998AbXCTFEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 01:04:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:51205 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbXCTFEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 01:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tKRucCwOKhgLMEuUZ9JmnZ+feWYDLdyBY5/cqIgYhgO7TbW9l3xs8/FcYYRqK7/Q2JZcPMReSr53u0Yr+izWdQTzImQA2ADM7Vi9B7V9u+TsfOS+Ke3erGpx53v2DgWg1iYs30YUVAXvehvVnloW1i+mnwuopalqxrlDeY1wATM=
Message-ID: <75b66ecd0703192204n503eb4d3g361064f66319dd4c@mail.gmail.com>
Date: Tue, 20 Mar 2007 01:04:48 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: tglx@linutronix.de
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so far
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Arjan van de Ven" <arjan@infradead.org>, "Len Brown" <lenb@kernel.org>
In-Reply-To: <1174088686.13341.347.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
X-Google-Sender-Auth: d4eca49dc31f6e85
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> Yes, this is probably caused by SMM code trying to emulate a PS/2
> keyboard from a (maybe connected or not) USB keyboard. Unfortunately we
> have no way to disable this BIOS misfeature in the early boot process.

https://mail.rtai.org/pipermail/rtai/2003-March/002949.html

http://www.embeddedrelated.com/usenet/embedded/show/50333-1.php

I think CONFIG_TRY_TO_DISABLE_SMI would be excellent for debugging,
not to mention people trying to spec out hardware for RT
applications...

Lee
