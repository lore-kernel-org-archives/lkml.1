Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbXC1KJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbXC1KJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 06:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933791AbXC1KJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 06:09:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:26437 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbXC1KJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 06:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YwepH9yHmNPeeq+kOXeJT35eRzVykHqv9004qhSfQBNwQyrh4AL/JiS/u7FYRTOuHLV1fushXHixGVcZc3uL7q8tAyInuootkPuK7dRRLbdM+ne0eAJ1azVLY+c8th+x3Ru3+5qYnVG6fimD1dOe7hcbv+wVtxSXlpAEAmwyTYo=
Message-ID: <84144f020703280309i4e47f9b8w92a369aa7bc16ece@mail.gmail.com>
Date: Wed, 28 Mar 2007 13:09:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 2/2] revoke: break cow for private mappings
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <460A2184.8060207@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703271014100.793@sbz-30.cs.Helsinki.FI>
	 <460A2184.8060207@yahoo.com.au>
X-Google-Sender-Auth: b7b37befd2ac7205
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > +             ret = get_user_pages(tsk, tsk->mm, vma->vm_start,
> > +                                  vma->vm_end-vma->vm_start, 1, 1, NULL,
> > +                                  NULL);
>
> get_user_pages length argument is in # of pages, rather than address range,
> I think. vma_pages is what you want?

Yes.

On 3/28/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > +     up_write(&mm->mmap_sem);
>
> I think you just need down_read of mmap_sem here?

Indeed. Thanks Nick.

                                  Pekka
