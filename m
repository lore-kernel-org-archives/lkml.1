Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbZAUJyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbZAUJyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZAUJyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:54:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:41428 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbZAUJyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WZOlW/5GWaRB0fPzceUaRlRKjcBLKWvnU8eYddhZ9yoEOU8qYX9GYWDtOb3A9V9jC3
         ARmsE87I380gskkofpcS3hlCXXR/8Hv11gK7strFmaiS6PCbZOUOGZ392PFFPx4eNiam
         0pYYDpgKbhQ/VIDxl4NukJCe+v/lcAW5MIwGQ=
Date: Wed, 21 Jan 2009 09:54:01 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: zbr@ioremap.net, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090121095401.GB5140@ff.dom.local>
References: <20090120102053.GA17004@ff.dom.local> <20090120103122.GC9167@ioremap.net> <20090120110144.GB17004@ff.dom.local> <20090120.091616.224452074.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120.091616.224452074.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 09:16:16AM -0800, David Miller wrote:
...
> Jarek, we already have a page and offset you can use.
> 
> It's called sk_sndmsg_page but that is just the (current) name.
> Nothing prevents you from reusing it for your purposes here.

I'm trying to get some know-how about this field.

Thanks,
Jarek P.
