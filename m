Return-Path: <linux-kernel-owner+w=401wt.eu-S1751494AbXB0EgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbXB0EgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXB0EgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:36:06 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:15190 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbXB0EgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:36:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ERKjh1OUDI9K0XLn50w3vrh2DtBkxQuX+uR6UYmyk87teFuNPVsUqavxm6BACl6HYaKQzJYOSAGKu/jpUVemldG9mCcRM326zG3/E4DYwDudicTxuGDGYqqL1WXqndfJTCin5RRvEUvIIGM+UvQ2UMOADkzJjA7Kq0wPvDy7zBI=
Message-ID: <21d7e9970702262036h3575229ex3bf3cd4474a57068@mail.gmail.com>
Date: Tue, 27 Feb 2007 15:36:03 +1100
From: "Dave Airlie" <airlied@gmail.com>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [patch 0/6] fault vs truncate/invalidate race fix
Cc: "Linux Memory Management" <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
In-Reply-To: <20070221023656.6306.246.sendpatchset@linux.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221023656.6306.246.sendpatchset@linux.site>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I've also got rid of the horrible populate API, and integrated nonlinear pages
> properly with the page fault path.
>
> Downside is that this adds one more vector through which the buffered write
> deadlock can occur. However this is just a very tiny one (pte being unmapped
> for reclaim), compared to all the other ways that deadlock can occur (unmap,
> reclaim, truncate, invalidate). I doubt it will be noticable. At any rate, it
> is better than data corruption.
>
> I hope these can get merged (at least into -mm) soon.

Have these been put into mm? can I expect them in the next -mm so I
can start merging up the drm memory manager code to my -mm tree..

Dave.
