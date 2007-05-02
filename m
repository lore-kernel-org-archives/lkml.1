Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbXEBFyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbXEBFyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 01:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXEBFyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 01:54:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbXEBFyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 01:54:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=c8QcsA5SztmNz0gQVJczoPvWHs9ur9R4jzab3NA/s+1fvzLvJBD3zNfs4dAvhko+H
	fET8VC2mdtyAdxEIozIeg==
Date: Tue, 1 May 2007 22:53:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <20070502051723.GB5843@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0705012252020.21669@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <20070502051723.GB5843@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Alexey Dobriyan wrote:

> On Tue, May 01, 2007 at 09:28:18PM -0700, David Rientjes wrote:
> > +#define __attribute_unused__		__attribute__((unused))
> 
> Suggest __unused which is shorter and looks compiler-neutral.
> 

So you would also suggest renaming __attribute_used__ and all 48 of its 
uses to __used?
