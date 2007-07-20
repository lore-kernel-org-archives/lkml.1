Return-Path: <linux-kernel-owner+w=401wt.eu-S939703AbXGTAzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939703AbXGTAzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbXGTAzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:55:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:27710 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbXGTAzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aCRcdxFVXbEjh8qEaNN+q+mYit6PrzrrcDKUjJz5/3rKXMGr9ZJzR07CS3IIryZn5LvmPsX7d9gubDuLipfFgiINw5td3r7XFTJY++0Hp6d0guhlw2wYkmE81FcLrX9ILmu+xuqJN0fyskjOoeRiELj/NL8yxb5h+zDXSW/Fnd8=
Message-ID: <9a8748490707191755m5c470440laae483821b99908e@mail.gmail.com>
Date: Fri, 20 Jul 2007 02:55:41 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David J. Wilder" <wilder@us.ibm.com>
Subject: Re: [PATCH] Fix a use after free bug in kernel->userspace relay file support
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tom Zanussi" <zanussi@us.ibm.com>,
       "Karim Yaghmour" <karim@opersys.com>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Paul Mundt" <lethal@linux-sh.org>
In-Reply-To: <469FB9FC.4050005@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707182311.10538.jesper.juhl@gmail.com>
	 <469FB9FC.4050005@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/07/07, David J. Wilder <wilder@us.ibm.com> wrote:
> ACK
> Thanks for catching this. Your patch looks fine. I tested for
> regression, no problems. I also tested the error path and had the
> expected results.

Ok, thank you for testing. I see that Mathieu Desnoyers also ack'ed
the patch (thank you Mathieu). Will you guys take care of getting it
merged upstream or should I resubmit it myself to Linus or Andrew with
your ACKs?


> Thanks
> Dave
>
> Jesper Juhl wrote:
> > Hi,
> >
> > Coverity spotted what looks like a real possible case of using a
> > variable after it has been freed.
> > The problem is in kernel/relay.c::relay_open_buf()
> >
[snip]

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
