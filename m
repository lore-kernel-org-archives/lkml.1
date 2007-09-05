Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbXIEMfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbXIEMfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 08:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754992AbXIEMfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 08:35:13 -0400
Received: from mail.tmr.com ([64.65.253.246]:40886 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbXIEMfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 08:35:11 -0400
Message-ID: <46DEA293.9020705@tmr.com>
Date: Wed, 05 Sep 2007 08:35:31 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
References: <46DA0AB1.8050504@tmr.com> <000701c7eb49$cff701c0$6fe50540$@com> <1188513433.6626.24.camel@heimdal.trondhjem.org> <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org> <5813.1188892468@redhat.com>
In-Reply-To: <5813.1188892468@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Bill Davidsen <davidsen@tmr.com> wrote:
>
>   
>> mount /base on point1 - rw	[ hopefully really r/w ]
>> mount /base on point2 - ro	[ hopefully r/o ]
>>     
>
> I think Al Viro probably has the right idea as to how to fix this: Move the
> R/O R/W flag into vfsmount and count the number of R/W vfsmounts in the
> superblock.  I never quite finished implementing the patch to do this, but I
> can go back and revisit it.
>   
I think Al had a good idea there, that is nice and clean. What about 
bind mounts, will that just fall out?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

