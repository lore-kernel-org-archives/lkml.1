Return-Path: <linux-kernel-owner+w=401wt.eu-S1763248AbXH3Xos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763248AbXH3Xos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 19:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXH3Xoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 19:44:39 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:35471 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbXH3Xoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 19:44:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=g0kdky4Bqyk2g7drxuW8O8w36Nro89+AdB/fzDFwb4QxPiP+jAl7FQZpDlqNz1A/FHhtaiwInHCmZPLhULCpUCTCVtAXSgPvDiW3izX7HP8poD/Zk8U/CVlAsNR41+WLv7zqCuWZb/IuPxmsPESlrJcMIQajlxC7V6yVPeAr71w=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Trond Myklebust'" <trond.myklebust@fys.uio.no>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>	 <1188513433.6626.24.camel@heimdal.trondhjem.org>	 <001001c7eb57$afd2d320$0f787960$@com>	 <1188516173.6626.46.camel@heimdal.trondhjem.org>	 <001501c7eb5d$d295d870$77c18950$@com> <1188517070.6626.54.camel@heimdal.trondhjem.org>
In-Reply-To: <1188517070.6626.54.camel@heimdal.trondhjem.org>
Subject: RE: recent nfs change causes autofs regression
Date: Thu, 30 Aug 2007 16:44:29 -0700
Message-ID: <001601c7eb5f$b6146980$223d3c80$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfrXslLLq2DQmjSQPCv1V+rVPb4QgAACNNg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> How is the NFS client to know that these directories are disjoint, or
> that no-one will ever create a hard link from one directory to another?
> To my knowledge, the only way to ensure this is to put them on
> different disk partitions.
> 
> I don't know if all Unix systems have this issue, but I have been told
> that Solaris at least has it.

Does Solaris enforces this "mount with same options" as default?

> > "working" as in "I can mount the directory and do my work". And there
> > has never been any problems as far as I know.
> 
> That is too narrow a definition: the minimum should be "everyone can
> mount their directories and do their work". Your particular setup may
> be safe, but that is why we have overrides: the default should be for the
> kernel to be conservative, and to _tell_ users what it thinks is wrong.

Every engineer in our organization mounts it too. No problem until now.

It's not very conservative to suddenly change default behavior and break
autofs mounts. There is not even one kernel message that "_tells_ user why
it thinks it's wrong". It just silently fails.

> Your choice.

No. I have no other choice as I explained before.

Hua

