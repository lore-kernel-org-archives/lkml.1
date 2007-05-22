Return-Path: <linux-kernel-owner+w=401wt.eu-S935309AbXEVTnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935309AbXEVTnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760665AbXEVTni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:43:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:21370 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535AbXEVTnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:43:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iYmOzzxvKpC28zh8x8jrbWfKT0x3F+6Y1qOqihoWNIbIa8gjr3XGpqg2YMGBMIHBmg69gczctbs6MhxcMzOArlgsWH5PUObPDKt5+reWL5YDX0a9evvhAAmck0sgplEue0d7VRqcuyB8H+4NIt52BSsARJepwoUZhVqLKoU6bTw=
Message-ID: <86802c440705221243t11208094r82c83f42fd4aa0a1@mail.gmail.com>
Date: Tue, 22 May 2007 12:43:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3]x86_64: early_printk for early debug port support
Cc: "Andi Kleen" <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Greg KH" <gregkh@suse.de>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070522123137.699d7a87.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705202219k5aa758ffk217626424e613ec7@mail.gmail.com>
	 <20070522123137.699d7a87.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> OK, I went through the exercise of removing all the unused-symbol warnings
> which DBGP_DEBUG=0 produces and guess what?  None of the code which you've
> added does anything!  It all has to be moved inside DBGP_DEBUG to avoid
> unused-symbol warnings.  It's all a big no-op if DBGP_DEBUG=0.  I suspect
> you did all your test and devel with DBGP_DEBUG=1, then turned DBGP_DEBUG
> off and shipped the code without retesting?

Thanks. will format and test again. also will use KMail to mail it out.

YH
