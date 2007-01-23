Return-Path: <linux-kernel-owner+w=401wt.eu-S932971AbXAWOWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbXAWOWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932975AbXAWOWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:22:35 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:14884 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971AbXAWOWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:22:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GALldRs4XpZZko0CPTRGJDevCDcjwV8CmsilXJBC11EZ9vA4m2mtS6j1g7E3zYccOqGF25CkaA0Zta/3QvWbLGJNNiJ6xVls9ymwCR9vjtRSjHNucV77qwRVGzmeCmFsO2gUHq3/2AaVO/37aTaea9KeiAJ205zxvv0GG1r2zYk=
Message-ID: <61ec3ea90701230621nd03f9c6jc996ca3d041a07ef@mail.gmail.com>
Date: Tue, 23 Jan 2007 15:21:22 +0100
From: "Franck Bui-Huu" <fbuihuu@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: revert "Fix up" of mmap_kmem
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@osdl.org>, "Nadia Derbey" <Nadia.Derbey@bull.net>,
       "Andi Kleen" <ak@suse.de>, "Arjan van de Ven" <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0701221642320.27059@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0701221642320.27059@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/07, Hugh Dickins <hugh@veritas.com> wrote:
> Please revert 2.6.19's 99a10a60ba9bedcf5d70ef81414d3e03816afa3f (shown
> below) for 2.6.20.  Nadia Derbey has reported that mmap of /dev/kmem no
> longer works with the kernel virtual address as offset, and Franck has
> confirmed that his patch came from a misunderstanding of what an offset
> means to /dev/kmem - whereas his patch description seems to say that he
> was correcting the offset on a few plaforms, there was no such problem
> to correct, and his patch was in fact changing its API on all platforms.
>

Yes I confirm, sorry for the confusion.
-- 
                Franck
