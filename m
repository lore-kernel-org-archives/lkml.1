Return-Path: <linux-kernel-owner+w=401wt.eu-S1765516AbXFRU0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765516AbXFRU0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763180AbXFRU0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:26:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:14861 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762843AbXFRU0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Qf0MswgYeUyrCJtdSkMzsOB980g5iXtThBCyDDxQg/d5DZw4J+vUPmoYvhU+RsXjzuA8qOxxOOSvhjiyODTOrrz85Thb+q5VDq2vpKUZRIm2SzlcLsCyGsi1t21WkiSvF4W2QqtayXO6R069gW6706ZJkJfeu+6euIWgSGFz/IY=
Message-ID: <84144f020706181326i6923cccdm21d122ee9eee8fb7@mail.gmail.com>
Date: Mon, 18 Jun 2007 23:26:41 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
In-Reply-To: <84144f020706181316u70145db2i786641d265e5bc42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095914.622685354@sgi.com>
	 <84144f020706181316u70145db2i786641d265e5bc42@mail.gmail.com>
X-Google-Sender-Auth: 866797594c0cdf64
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hmm, did you check kernel text size before and after this change?
> Setting the __GFP_ZERO flag at every kzalloc call-site seems like a
> bad idea.

Aah but most call-sites, of course, use constants such as GFP_KERNEL
only which should be folded nicely by the compiler. So this probably
doesn't have much impact. Would be nice if you'd check, though.
