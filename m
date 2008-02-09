Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbYBITT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbYBITT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYBITTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:19:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:10536 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680AbYBITTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SGvdG/UwcUQn4y/haXnwVlOBL6088IhXLJr7kr7yNPsq5IXxc5TZ6KttT6mJFvdriHPeWrHFTJPibsWUClfx5UOlRHCi8OOga3Vowp5+Ya7cDEAE2hFdz89z2eptRuaYLj7A3kbiY1ivzOEMn1YNKMkqGjL9Mrr8q4R90Fskyic=
Message-ID: <84144f020802091119s25c81627k921dd98bc2b677b9@mail.gmail.com>
Date: Sat, 9 Feb 2008 21:19:17 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [RFC PATCH] x86: explicit call to mmiotrace in do_page_fault()
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080209211155.1dd8dc3b@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201660453.8837.13.camel@brick>
	 <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	 <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
	 <20080207125327.GB27234@elte.hu> <20080207125622.GA7111@infradead.org>
	 <20080209195255.584d4157@daedalus.pq.iki.fi>
	 <20080209100133.60406c00@laptopd505.fenrus.org>
	 <20080209202353.0e83e337@daedalus.pq.iki.fi>
	 <84144f020802091056hffc22eckbda461534e3a6072@mail.gmail.com>
	 <20080209211155.1dd8dc3b@daedalus.pq.iki.fi>
X-Google-Sender-Auth: fc7dd25c9a48461b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Feb 9, 2008 9:11 PM, Pekka Paalanen <pq@iki.fi> wrote:
> No difference. I just have to do it at some point. I can't work on this
> every day and when it comes to kernel, I'm a complete newbie. So things
> will take time. If people want that I fix this before mmiotrace goes into
> mainline, then so be it.

Not my call but please keep in mind that once it's in the kernel we
can't go breaking the ABI (well, we might as this is strictly a
debugging mechanism, but still). Anyway, it shouldn't be that hard to
implement and there are plenty of examples in the kernel and you can
always as for help if you hit a brick wall ;-).

                         Pekka
