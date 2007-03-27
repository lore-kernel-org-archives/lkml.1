Return-Path: <linux-kernel-owner+w=401wt.eu-S965291AbXC0HUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbXC0HUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965301AbXC0HUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:20:35 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:42563 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291AbXC0HUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L8L9JPuYCalbuZqXC9S80Fry8X/dP9UZf4SZWrqoluwrZGfUqULB7eTsQFSJR1+hPcrDr9OMShbWrYBmpjEtMV2t4Lr9yDVjMOdfisG4xOs4tbtzPkEV0EOBT4PNH5uA36OduaknivnReZImjQCYU29dZU8NpxAN2/MSuN3fLnQ=
Message-ID: <8bd0f97a0703270020m67821b90gb9d1cdfd6262887b@mail.gmail.com>
Date: Tue, 27 Mar 2007 03:20:33 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Pekka J Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug
Cc: "Wu, Bryan" <bryan.wu@analog.com>, "David Howells" <dhowells@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0703270955490.32526@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703261447190.13229@sbz-30.cs.Helsinki.FI>
	 <1174904637.32691.86.camel@roc-desktop> <6017.1174908318@redhat.com>
	 <6791.1174909459@redhat.com> <11045.1174911764@redhat.com>
	 <Pine.LNX.4.64.0703261525370.14158@sbz-30.cs.Helsinki.FI>
	 <22674.1174915478@redhat.com>
	 <8bd0f97a0703261321h356a849am1ab617f0e732fa67@mail.gmail.com>
	 <1174966174.6966.5.camel@roc-desktop>
	 <Pine.LNX.4.64.0703270955490.32526@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> On Tue, 27 Mar 2007, Wu, Bryan wrote:
> > Agree. MPU of Blackfin can provide some processes protection. But maybe
> > at this moment just disable revoke for NOMMU is easier for further
> > development. When we provide the MPU stuff, maybe we can enable the
> > revoke for NOMMU but MPU arch.
>
> Yeah, MPU should be sufficient for revoke(). Note that mmap() and mummap()
> suffers from the same problem on NOMMU so perhaps we really should do
> CONFIG_MPU.

we would need both ... MPU gives us the ability to restrict access,
but we'd still be unable to do fun things like COW
-mike
