Return-Path: <linux-kernel-owner+w=401wt.eu-S1031210AbXDZOfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031210AbXDZOfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031184AbXDZOfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:35:50 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.8]:2558 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031210AbXDZOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:35:49 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Frederik Deweerdt <deweerdt@free.fr>
Subject: Re: Linux 2.6.21 - something wrong with dmesg.
Date: Thu, 26 Apr 2007 15:35:46 +0100
User-Agent: KMail/1.9.6
Cc: Sunil Naidu <akula2.shark@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com> <20070426130339.GB16833@slug>
In-Reply-To: <20070426130339.GB16833@slug>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261535.46568.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 April 2007 14:03:39 you wrote:
> On Thu, Apr 26, 2007 at 05:44:40PM +0530, Sunil Naidu wrote:
> > Hello,
> >
> > I did compile the kernel, boots good ;-) BTW, does anyone (on P-III)
> > facing a memory check skip or sort of? Not getting RAM info in the
> > dmesg.  Unable to get dmseg from the start of the gcc check! Any clue?
> > Here is the dmesg I get on my box:
>
> Don't you need to increase CONFIG_LOG_BUF_SHIFT ?

May also simply be that you need to pass dmesg -s 64000 or something similar, 
because it defaultly only dumps 16K of the kernel log buffer (regardless of 
the CONFIG setting).

(Also, does Andrew really need to be CCed twice?)

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
