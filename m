Return-Path: <linux-kernel-owner+w=401wt.eu-S965369AbXCPOqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369AbXCPOqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965370AbXCPOqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:46:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:3659 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965336AbXCPOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=axk82Ztgc5O0X1geg/GI5iGbRvV2jGKM1UWko0u7V6hF0ekOJsVgv+nlewyxWbQ+hiweUUqBjtzPlQUiPqwwfRK5Ro6ArAktNrRMA6gXXWW++e36E5jY810ZtdMLyT8XPqxgWAhIMCNpjb6LJzXvmGPrzScMhm6ggLNd8aICHQY=
Message-ID: <84144f020703160746v73268f1erae778590e56c4274@mail.gmail.com>
Date: Fri, 16 Mar 2007 16:46:42 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/5] revoke: core code
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <84144f020703160727lc142577racfade12ed04cfc7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	 <20070315173438.efadd514.akpm@linux-foundation.org>
	 <84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
	 <20070316032624.c6db84fc.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
	 <20070316042600.3e1bd424.akpm@linux-foundation.org>
	 <20070316145855.5604d7d8@lxorguk.ukuu.org.uk>
	 <84144f020703160727lc142577racfade12ed04cfc7@mail.gmail.com>
X-Google-Sender-Auth: ac110a0131d13e57
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Serious question - do we actually need revoke() on a normal file ? BSD
> > has never had this, SYS5 has never had this.

On 3/16/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> It's needed for forced unmount (bits of it anyway) and
> partial-revocation in SLIM.

And btw, you do need support for tearing down mmap for device files too, right?
