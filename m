Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbXHBNSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbXHBNSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXHBNSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:18:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:47712 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbXHBNSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SGWSZLsVEsAeW35FcbmwiUprcTcGnbBaatVBDnXJIk+YRVK3tfGtFYhhUAup+1CVo3DYmzKye3euR4WPy/hu4RKhs/+i6H+EhpQ3yWPdxjIC3B220Qxn8WK7s2DogG8YhQsAl5OjEk80s1LeOxGx9H4DByIcEjph8+JLxVyjxSA=
Message-ID: <3d8471ca0708020618g5b7cf05dr350c25626137a13e@mail.gmail.com>
Date: Thu, 2 Aug 2007 15:18:33 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: mmap behavior on out-of-space conditions
Cc: "Petr Tesarik" <ptesarik@suse.cz>, "Dave Chinner" <dgc@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1186059975.12034.111.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186058486.2289.17.camel@elijah.suse.cz>
	 <1186059975.12034.111.camel@twins>
X-Google-Sender-Auth: c479a9a2e4c072f0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/8/2, Peter Zijlstra <peterz@infradead.org>:

> I think Dave's block_page_mkwrite() stuff addresses this as well, no?
>
> http://lkml.org/lkml/2007/3/18/198

I saw a similar problem some time ago with msync:
http://lkml.org/lkml/2006/12/29/136 but Andrew didn't
like my patch.

-- 
Guillaume
