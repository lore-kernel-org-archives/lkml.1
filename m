Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbZBIKGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbZBIKGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZBIKGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:06:35 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:60987 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZBIKGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:06:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IxjKwz+jhv/81oUcrIUZZVkFZ/Egc6tv8jqylzrJz9w68YKCCriJsioI1gZkrQz/0M
         pDZVP0xdI4Jlgla17OgTNUuz1DqEkcUUshH+80apXD8rBPswBL3BiFOAvecK5gCe3oFK
         8BwdnojYkgYnn6Ig5KceVJJ/IF3OxXQ70qUrM=
MIME-Version: 1.0
In-Reply-To: <200902091659.21446.nickpiggin@yahoo.com.au>
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com>
	 <c43b2e150902080209s2444718fjb08086eed1a835cc@mail.gmail.com>
	 <c43b2e150902080225kefc3f0bk89aa270397bcc33f@mail.gmail.com>
	 <200902091659.21446.nickpiggin@yahoo.com.au>
Date: Mon, 9 Feb 2009 11:06:32 +0100
Message-ID: <c43b2e150902090206n4fd45d24xedbf5074535cf574@mail.gmail.com>
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
From: wixor <wixorpeek@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, that is somehow better. BUG is gone, it says now
   vmap allocation failed: use vmalloc=<size> to increase size
and then
   ioremap failed.
The driver still doesn't work however.

--
wixor
