Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbXDKIPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbXDKIPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXDKIPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:15:46 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:13109 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXDKIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N8nPdBNMi1w/dvE4gpBfjLKX3r//aHamUz/56URlMEWyC0SVG2aHT+X3aAhdTetrgjvOK6uCUDH1xhj0eBZn8mndZpGnYwhz28WMyPumah2i/Z78361Nsw/pmjw9U2bFGLu7Ocu3nLHzkszqJY81G2qIvehr0C6xu34ZHtUh/VM=
Message-ID: <6e0cfd1d0704110115j1153e4ecn3725e7787233e0e2@mail.gmail.com>
Date: Wed, 11 Apr 2007 10:15:42 +0200
From: "Martin Schwidefsky" <schwidefsky@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: link error : 2.6.21-rc6-mm1 for s390
Cc: "David Miller" <davem@davemloft.net>, mathieu.desnoyers@polymtl.ca,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       shemminger@linux-foundation.org, heiko.carstens@de.ibm.com
In-Reply-To: <20070410233919.0fa4894e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410182937.8169c672.akpm@linux-foundation.org>
	 <20070410.183629.57444787.davem@davemloft.net>
	 <20070410184738.dc1c5943.akpm@linux-foundation.org>
	 <20070410.221101.110908614.davem@davemloft.net>
	 <20070410233919.0fa4894e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 10 Apr 2007 22:11:01 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> I think this means that if CONFIG_32BIT=y, s390 networking gets the whizzy
> assembly version and if CONFIG_32BIT=n, it gets to use the generic version.
>
> Possibly the whizzy version could be used if CONFIG_32BIT=n, too.  But
> I'd let the s390 people worry about that ;)

If CONFIG_32BIT=n we don't need __div64_32 at all, do we? Just use the
real 64 / 64 bit division.

-- 
blue skies,
  Martin
