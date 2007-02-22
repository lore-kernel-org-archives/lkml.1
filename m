Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbXBVJtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbXBVJtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbXBVJtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:49:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:56208 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXBVJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:49:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YP3lWmH7e96UeXWUwLk0yLPC1LrCxx2ivDk+WdT1knMlL/lmMAXQ+rJEaeszWreMkRqupXpsUYZI/9z9mffS/gPD8AIxJn7z35rfDRfawaMI6M3XvE1SeIqEE7DDBO4EXU3WyDgOxrAqMYlMFE3M+SQTpTYvVW8+PNf8uYlNUB4=
Message-ID: <84144f020702220149m21543847ge6af27e0468a5c86@mail.gmail.com>
Date: Thu, 22 Feb 2007 11:49:16 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/29] mm: kmem_cache_objs_to_pages()
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Thomas Graf" <tgraf@suug.ch>, "David Miller" <davem@davemloft.net>
In-Reply-To: <84144f020702220145h4f670ec6g428dc046ee9dcc71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221144304.512721000@taijtu.programming.kicks-ass.net>
	 <20070221144842.299190000@taijtu.programming.kicks-ass.net>
	 <84144f020702210747t50d7d92ei1a2f5da8bf117d40@mail.gmail.com>
	 <1172136508.6374.41.camel@twins>
	 <84144f020702220145h4f670ec6g428dc046ee9dcc71@mail.gmail.com>
X-Google-Sender-Auth: d8585ad940c1a080
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> So you are only interested in rough estimation of how much many pages
> you need for a given amount of objects? Why not use ksize() for that
> then?

Uhm, I obviously meant, why not expose obj_size() instead.
