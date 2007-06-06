Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbXFFEOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbXFFEOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXFFEOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:14:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:22608 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXFFEOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g15PoMmO7gVs5uW0y3rP1jso115uSmdnADWn5miD98ymr0U+DVZsUpVHSKiJVqhAUGaXcxTRS4QaBeknTFSb1iajlAn2QbputVBsOlnZkLjz5x8P/o8wDuxBKqidIF41AWCdlAcQNUQKei67EnIMJ/b5LsTUws0MQJRmo1Ev0xc=
Message-ID: <86802c440706052114s4bd3d2bap653c58f37ed14120@mail.gmail.com>
Date: Tue, 5 Jun 2007 21:14:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: change dm_ioremap to ioremap
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706051206.52012.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440706042321k4d83a33dpa0a09deb5fbd5a3a@mail.gmail.com>
	 <200706051206.52012.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/07, Andi Kleen <ak@suse.de> wrote:
> init_memory_mapping is not enough; it also needs a working
> page allocator. But at this point there is only bootmem.
> I don't think the patch is correct.

you are right  it failed with one 2G system.

YH
