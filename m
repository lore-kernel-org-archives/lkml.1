Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbXEIMHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbXEIMHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbXEIMHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:07:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:49115 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbXEIMHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:07:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tN9xD60HMAn2wL36+faKNYSIXqW5DGK0CqwUtCiF5aD3K8RTrvX7NdYL+VDYsGeelc20G5/jG8LZitpXd+WR+X313lJkzTcOAht1Ou7PVCnSOpV6ditHyXHxecMfuEkkV7rzZ7q9lwuNfFf3p/BLUb3pAFu48zKHa0ItwEN8Km4=
Message-ID: <5d6222a80705090507h4fdbf4f5x439d3991c1c9b7b8@mail.gmail.com>
Date: Wed, 9 May 2007 09:07:19 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] Fix a bad bug in read_cache_page_async()
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070509120201.6771.92968.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070509120201.6771.92968.stgit@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>         page = __read_cache_page(mapping, index, filler, data);
>         if (IS_ERR(page))
> -               goto out;
> +               goto error;
any reason for not simply returning page here?


>                 page = ERR_PTR(err);
> +               goto error;
same


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"

"The less confident you are, the more serious you have to act."
