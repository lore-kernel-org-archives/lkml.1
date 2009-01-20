Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbZATOGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbZATOGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZATOGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:06:19 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:53695 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbZATOGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:06:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VRqVmK7mDbkJnxnx/dYPJgWRPBrA63W2pSztJnfz4/a6NoJq1z/1Q/rPzGwi9ewNrk
         dDfwzhFdxynyHsWjWK7OjjGGmM9VKGrfUQQ0fftZGqYA9rvBPXdS63GtmOE3w/+bSBRv
         +nF28l3RmhXLekxkpr8nT/njoITbSn7xc9vm4=
Date: Tue, 20 Jan 2009 14:06:11 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Ben Mansell <ben@zeus.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       dada1@cosmosbay.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090120140611.GC17004@ff.dom.local>
References: <20090115.153449.204259387.davem@davemloft.net> <20090115234255.GE1123@1wt.eu> <20090115234408.GA1693@1wt.eu> <20090115.155434.206643894.davem@davemloft.net> <20090119004206.GA10396@1wt.eu> <4975BD09.3020103@zeus.com> <20090120121115.GA17277@ioremap.net> <4975D518.1000800@zeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4975D518.1000800@zeus.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 01:43:52PM +0000, Ben Mansell wrote:
...
> With an unpatched kernel, the splice performance was worse (due to the  
> one packet per-splice issues). With the small patch to fix that, I was  
> getting around 2 Gbps performance, although oddly enough, I could only  
> get 2 Gbps with read()/write() then as well...
>
> I'll try and do some tests on a machine that hopefully doesn't have the  
> bottlenecks (and one that uses different NICs)

I guess you should especially check if SG and checksums are on, and it
could depend on a chip within those NICs as well.

Jarek P. 
