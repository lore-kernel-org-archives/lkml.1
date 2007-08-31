Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbXHaTgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbXHaTgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 15:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbXHaTfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 15:35:50 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:14228 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXHaTft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 15:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=jjD3wHxjQxc448xDT7PfM8vUN1yYRgspdeVZ+95m2Wea9mILJ8DYDf/idziHgDq5eQfBfBqFP/nqsHYuwYkgbuED+vS3vBSNL01bDlC3XMWhosBCqSNi8VkIkoVUkmFiBSp4nHRmiQ5BmNJBw9JqE/IQ+ECqEJiwAJfDwb4UxMk=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Trond Myklebust'" <trond.myklebust@fys.uio.no>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Frank van Maarseveen'" <frankvm@frankvm.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>	 <1188513433.6626.24.camel@heimdal.trondhjem.org>	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>	 <1188577275.6649.133.camel@heimdal.trondhjem.org>	 <006a01c7ebff$709354c0$51b9fe40$@com> <1188587601.19730.45.camel@heimdal.trondhjem.org>
In-Reply-To: <1188587601.19730.45.camel@heimdal.trondhjem.org>
Subject: RE: recent nfs change causes autofs regression
Date: Fri, 31 Aug 2007 12:35:37 -0700
Message-ID: <006b01c7ec06$1c8d9c30$55a8d490$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfsAwZpqgwnfKeOSGi52XTjHDLJnwAAoPPw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2007-08-31 at 11:47 -0700, Hua Zhong wrote:
> > This patch fixes the problem for me, thanks.
> >
> > Is this patch changing the behavior of "sharecache" to
> > "try-to-share-cache-if-possible", or adding a third behavior? If the
> > user explicitly asks for "-o sharecache", does he get an error back
> > if the mount options mismatch?
> 
> There has never been a 'sharecache' flag as far as the kernel is
> concerned. The default behaviour has always been to share.

It's not about default (for which backward compatibility is most important
and this patch is perfectly fine), but user explicitly asks for
"sharecache". In this case if for any reason the cache cannot be shared, I
am not sure if he should get an error back.

I for one agree with Ian and Linus that changing default to nosharecache
might be the best thing to do, but since I am now able to use the latest
kernel, I am very happy already.

Thanks a lot for your attention to my problem. :-)

> Trond


