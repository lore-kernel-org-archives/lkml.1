Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbXKMMQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbXKMMQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXKMMQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:16:14 -0500
Received: from embla.aitel.hist.no ([158.38.50.22]:54753 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbXKMMQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:16:13 -0500
Message-ID: <47399432.4090908@aitel.hist.no>
Date: Tue, 13 Nov 2007 13:10:26 +0100
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Yoav Artzi <yoavar@checkpoint.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE on 64bit and 32bit machines
References: <473865BE.2070806@checkpoint.com>
In-Reply-To: <473865BE.2070806@checkpoint.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yoav Artzi wrote:
> According to my knowledge the PAGE_SIZE on 32bit architectures in 4KB. 
> Logically, the PAGE_SIZE on 64bit architectures should be 8KB. That's 
> at least the way I understand it. However, looking at the kernel code 
> of x86_64, I see the PAGE_SIZE is 4KB.
>
>
> Can anyone explain to me what am I missing here?
Only that there are no connection at all between the page size and
the number of bits the processor uses.


The cpu designer simply makes independent decisions for both cases.
So i386 uses 4kB pages because intel designed their processor that way.
And x86_64 uses 4kB pages because AMD designed the architecture that way.
And some processors use 8kB or 16kB pages because that is how they work.
A few  processors offer a selection of page sizes, it is then up to the
architecture maintainer to make a choice between them. No such choice
exists for intel/amd, unless you count the unrealistic option
of using generic 2MB pages.

Having said that, it is possible to get a feel of what a 8kB page system
will be like on intel, by always allocating pages in pairs.

Helge Hafting
