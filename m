Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZBYWku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZBYWku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760502AbZBYWkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:40:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45441 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZBYWkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:40:35 -0500
Message-ID: <49A5C754.7000408@zytor.com>
Date: Wed, 25 Feb 2009 14:33:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Justin Chen <jchen@hpdst41.cup.hp.com>, linux-arch@vger.kernel.org,
       bjorn.helgaas@hp.com, justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] bitops: Change the bitmap index from int to unsigned
 long [frv]
References: <200902250452.UAA12902@hpdst41.cup.hp.com> <16693.1235565430@redhat.com>
In-Reply-To: <16693.1235565430@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> 
>> -static inline int __constant_test_bit(int nr, const volatile void * addr)
>> +static inline int
>> +__constant_test_bit(unsigned long nr, const volatile void *addr)
> 
> Please move the return type onto the next line also.  Other than that:
> 
> Acked-by: David Howells <dhowells@redhat.com>

What makes you say that, in particular?   A casual grep finds no less 
than 3524 instances of "static inline <type>" -- presumably with a 
function name following -- and only 447 instances of "static inline" 
without a type in the kernel.

	-hpa
