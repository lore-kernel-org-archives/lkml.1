Return-Path: <linux-kernel-owner+w=401wt.eu-S1161139AbXBUJd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139AbXBUJd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 04:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161140AbXBUJd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 04:33:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:51118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139AbXBUJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 04:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=C+JyYvuwRk1NY35ZT5Hl3yG3941jZaaTRhMHZ6lDNnJhaACmnZ6tYx3c7KZtpQtGbNidaXlccuJ3TZGe7s6xVH7Iwb/IsFPeC+U08FGJtRvJqAUxQoiPRMDvKTx3hubhIoYMqnVLvBVy24szDrGyKXxeSJSBplnLVa0oz+A6h8U=
Message-ID: <84144f020702210133k4a9f40f0mc0f51524fac9c524@mail.gmail.com>
Date: Wed, 21 Feb 2007 11:33:25 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 1/3] slab: introduce krealloc
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
In-Reply-To: <1172049875.3531.169.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
	 <1172049875.3531.169.camel@laptopd505.fenrus.org>
X-Google-Sender-Auth: fb36c5f6dae18dba
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Arjan van de Ven <arjan@infradead.org> wrote:
> please mark this one __must_check.. not storing realloc() return values
> is one of the more nasty types of bugs... but gcc can help us greatly
> here ;)

So I guess we want the same thing for the other allocator functions
(__kmalloc et al) as well?
