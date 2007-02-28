Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbXB1Qbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbXB1Qbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXB1Qbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:31:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:34286 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXB1Qbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SffSeIYUxUspzLSk5sT5uG/MYbIsKhdDV/snEUpjr3g/s51cUr5+WQGmHAaf3fWG1OTW6N+2qKhC5jJqDvxhrUNb54kPQ3p0SDXrFRf4E1q38rmpZnWBHssdhBVk+oX+I8kevDw7mlR5W+nIwuG0KXAZImqw0eiZvc96tDgLfOY=
Message-ID: <82ecf08e0702280831s55f404f2w26257f6061bb5239@mail.gmail.com>
Date: Wed, 28 Feb 2007 13:31:40 -0300
From: "Thiago Galesi" <thiagogalesi@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Wanted: simple, safe x86 stack overflow detection
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <45E5913D.3080505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45E5913D.3080505@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I guess most stack corruptions touch only a small part of the stack.
These kinds of corruptions can only be detected from inside the
program.

Anyway, going beyond the program's stack boundaries  would fault the program.

Checking the threadinfo constantly it'll be (IMHO) mostly useless...

On 2/28/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Can we just put a canary in the threadinfo and check it on every
> task switch? What are the drawbacks?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
-
Thiago Galesi
