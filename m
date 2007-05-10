Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbXEJPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbXEJPvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbXEJPvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:51:03 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:38489 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXEJPvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uXhCkplL7R4Abkf46/VCv+P1TvJYmEZhWhxYhsgBNXTw6ZcEgwMEk3hayF6MBUkB5VsfoeciqHXbZXIT503XCqA8uDSPBaMdyjh2u6QSl0X7HqEzT90HMF7xLYm860ffrvO/1tHtdLN+5AIarKi6c05o6r/OYZg69fXDL6SMraw=
Message-ID: <b6fcc0a0705100851q70381238t55542f60fbbdbb8e@mail.gmail.com>
Date: Thu, 10 May 2007 18:51:01 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Florin Iucha" <florin@iucha.net>
Subject: Re: Current git fails to compile on AMD64 for three days in a row
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070510151642.GH26751@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070510151642.GH26751@iucha.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Florin Iucha <florin@iucha.net> wrote:
> I just pulled the current git (de5603748af8bf7deac403e6ba92887f8d18e812)
> and tried to compile it on my AMD64 box, to test Chuck's RPC fix.  It
> fails:
>
>    arch/x86_64/kernel/head64.c: In function 'x86_64_start_kernel':
>    arch/x86_64/kernel/head64.c:70: error: size of array 'type name' is
> negative

Multiplying CONFIG_PHYSICAL_START by two in .config should fix it.
