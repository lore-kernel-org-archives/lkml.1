Return-Path: <linux-kernel-owner+w=401wt.eu-S1751498AbZH1NnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbZH1NnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 09:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZH1NnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 09:43:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60399 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbZH1NnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 09:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pN4bxhvVL89kl647aLFrUmY5GIb3ro47DESWkJt6aUmE6o0GNse7gmMMAoLZDdydK2
         rmkXSJ12H7puTynL7f1h7+ETq55FJRee5f6jlObE8cT8djTIFL8KUE04UXrG941gwfI8
         U1u4M1mN4xRnUxDDiH8eogPfdO3eJf2MsTJpE=
MIME-Version: 1.0
In-Reply-To: <20090828133631.GF5054@csn.ul.ie>
References: <1251449067-3109-1-git-send-email-mel@csn.ul.ie>
	 <1251449067-3109-3-git-send-email-mel@csn.ul.ie>
	 <84144f020908280516y6473a531n3f11f3e86251eba4@mail.gmail.com>
	 <20090828125719.GE5054@csn.ul.ie>
	 <1251464564.8514.3.camel@penberg-laptop>
	 <20090828133631.GF5054@csn.ul.ie>
Date: Fri, 28 Aug 2009 16:43:05 +0300
X-Google-Sender-Auth: b6793ec767fcb35f
Message-ID: <84144f020908280643h49799b94g270090f22c7cf5e0@mail.gmail.com>
Subject: Re: [PATCH 2/2] page-allocator: Maintain rolling count of pages to 
	free from the PCP
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 4:36 PM, Mel Gorman<mel@csn.ul.ie> wrote:
> This is PCPU draining. The flags are already clear of any values of interest
> and the order is always 0. I can follow up a fix-patch that reverses it just
> in case but I don't think it makes a major difference?

Aha, OK. Probably not worth it then.

                             Pekka
