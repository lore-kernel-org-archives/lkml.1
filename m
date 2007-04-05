Return-Path: <linux-kernel-owner+w=401wt.eu-S1767134AbXDEUnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767134AbXDEUnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767301AbXDEUnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:43:13 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:57932 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767134AbXDEUnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cHYDIBv+srwuFci/Y+CFnVTIdkiQsPgvB0TG58MPLX4gNjSvG6Nq2vUAT0um9AzJXbXz0DHcdoGF8gRqaeRBA74bb5ymtBhiACn5wWLlj2qkGVGgmTiFfsVLSwkZsKHNkeN2GLIHHPkeGJFS8uKP1vrx4jYTwqb85CxcEKlVIqE=
Message-ID: <a36005b50704051343s369b5bfgc07835df751fffb3@mail.gmail.com>
Date: Thu, 5 Apr 2007 13:43:09 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [PATCH] FUTEX : new PRIVATE futexes
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dave Jones" <davej@redhat.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       "pravin b shelar" <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070405194942.1414c030.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20060808070708.GA3931@localhost.localdomain>
	 <200608090826.28249.dada1@cosmosbay.com>
	 <200608090843.52893.dada1@cosmosbay.com>
	 <200703152010.35614.dada1@cosmosbay.com>
	 <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	 <20070405194942.1414c030.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> ---
>  include/linux/futex.h |   45 +++++-
>  kernel/futex.c        |  294 +++++++++++++++++++++++++---------------
>  2 files changed, 230 insertions(+), 109 deletions(-)

I cannot vouch for the whole code but the concept is very sound and
definitely along the way the specification allows it:

Acked-by: Ulrich Drepper <drepper@redhat.com>
