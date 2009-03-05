Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZCEDnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZCEDnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 22:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZCEDnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 22:43:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:34891 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZCEDnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 22:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bwQd4O1foCrV9AyPigokqk8z57nSdVX/BPNqYeTBJpx2kxUmfwSRdPUB9ZHyafufkn
         Gz7a+c/rUoIMFwTPy6gtVcqfMetGCfOsiM5EDJ3ELhbyaJCF3z6hB7krKSRjyEq1ar+3
         e2X0qgq4AqQ0fcEMpoZCl+jFH5j6TxfsMrSz4=
MIME-Version: 1.0
In-Reply-To: <20090304155544.3bc3f337.akpm@linux-foundation.org>
References: <20090303063605.GA30258@july>
	 <20090303124948.dda294e5.akpm@linux-foundation.org>
	 <49AE6907.1080702@nokia.com>
	 <20090304085055.c9de6cbb.akpm@linux-foundation.org>
	 <9c9fda240903041547x540899f9hd94cbf49baac660b@mail.gmail.com>
	 <20090304155544.3bc3f337.akpm@linux-foundation.org>
Date: Thu, 5 Mar 2009 12:43:06 +0900
X-Google-Sender-Auth: 4a5e35e7cc6b0abd
Message-ID: <9c9fda240903041943m483db3f4i3c40c6970ef16fce@mail.gmail.com>
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
From: Kyungmin Park <kmpark@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       AMIT KUMARSHARMA <amitsharma.9@samsung.com>
Cc: adrian.hunter@nokia.com, h.rohit@samsung.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 5, 2009 at 8:55 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 5 Mar 2009 08:47:03 +0900
> Kyungmin Park <kmpark@infradead.org> wrote:
>
>> I think we know the issues currently and then if the device is opened,
>> handle this one if required.
>> How do you think?
>
> I think it would be prudent to fix the known problems now, rather
> than having to go through and re-debug them later on.
>
> Bear in mind that people frequently copy old code when writing
> new code, so these things tend to propagate, creating more work
> later on.
>

Agree,

To Amit,

Could you fix it and send a patch please.
Also can you reduce the left shift operation to resolve it permanently

Thank you,
Kyungmin Park
