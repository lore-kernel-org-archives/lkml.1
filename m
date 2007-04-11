Return-Path: <linux-kernel-owner+w=401wt.eu-S1161323AbXDKWrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323AbXDKWrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161333AbXDKWrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:47:19 -0400
Received: from mx.pathscale.com ([198.186.3.68]:52412 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161323AbXDKWrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:47:19 -0400
Message-ID: <461D6593.1050009@pathscale.com>
Date: Wed, 11 Apr 2007 15:47:47 -0700
From: Robert Walsh <rjwalsh@pathscale.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
Cc: "Bryan O'Sullivan" <bos@pathscale.com>, openib-general@openfabrics.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ofa-general] Re: [PATCH 00 of 33] Set of ipath patches for 2.6.22
References: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>	<aday7kzooa7.fsf@cisco.com> <461D600E.4070709@pathscale.com> <ada3b36lex1.fsf@cisco.com>
In-Reply-To: <ada3b36lex1.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > BTW: any idea how this ever got triggered?  The only way I can see is
>  > if you're either not using libipathverbs and libibverbs and you just
>  > create the CQ some other way, which seems unlikely.  Do you know how
>  > Jason triggered this bug?
> 
> Yes, it was because he was using 32-bit userspace and so it was
> impossible to libipathverbs to mmap the address the kernel driver was
> looking for.  So the mmap failed and the pending mmap never got taken
> off the list.

Oh, OK.  Got it.  That problem is on my list, too, along with the other 
pending_mmap-related cleanups you suggested.  Hopefully I'll have a 
patch finished tonight.
