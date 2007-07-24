Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbXGXOAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbXGXOAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXGXOAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:00:42 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:31719 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbXGXOAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=J09Xb310i8TwT80oK2A6qK0Uvky+OLNHAca6IddSMXOb50SDl4g3aVcbc443kXRdnJBU9qRRUvVzb1+EBYLwwg1sDM+m7aKT2mEMhwQlfJJuHfJTSqYBYYqiYRA8l1EK+5nNNVIfDsxFf+9xMziecwORBgppyKoAbsxb6kswuzk=
Message-ID: <e9c3a7c20707240700o51362addm7c8398b83a539d56@mail.gmail.com>
Date: Tue, 24 Jul 2007 07:00:40 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
Cc: "Jens Axboe" <jens.axboe@oracle.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       mark.fasheh@oracle.com, "Nelson, Shannon" <shannon.nelson@intel.com>
In-Reply-To: <20070724013455.691e6752.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <20070723132431.42afbae8.akpm@linux-foundation.org>
	 <20070723204045.GD5755@martell.zuzino.mipt.ru>
	 <20070723210153.GA5753@martell.zuzino.mipt.ru>
	 <20070723141137.171e4ac1.akpm@linux-foundation.org>
	 <20070723220446.GA5822@martell.zuzino.mipt.ru>
	 <20070723152712.02ded067.akpm@linux-foundation.org>
	 <20070724081750.GM3287@kernel.dk> <20070724082207.GN3287@kernel.dk>
	 <20070724013455.691e6752.akpm@linux-foundation.org>
X-Google-Sender-Auth: e58cbc86f29cc0a2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
[...]
> > What about the new async crypto stuff? I've been looking, but is it
> > guarenteed that async_memcpy() runs in process context with interrupts
> > enabled always? If not, there's a km type bug there.
>
> I think Shannon maintains that now.
>

I am looking after the async_tx API, I will send a patch to update
MAINTAINERS shortly.

--
Dan
