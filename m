Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbZCCGoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbZCCGoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 01:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZCCGon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 01:44:43 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:42380 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZCCGom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 01:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v3RzSqHNk6bCpIXH13okwsMDH6REEHQxCCFUY0Wc/W7sHNePOPxIm0ITfB6lcfB96j
         yUbWEmq2ItbBjDHq6n/EiiJfQZ27sy3G3yAd9988MYXdwPXVtcD3ArgUs9C+vlJ5ta1n
         /Vty1bCxZFWnsVGuLygAVQsTPp8mhy86s6WPU=
MIME-Version: 1.0
In-Reply-To: <49ACC6B0.409@garzik.org>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>
	 <49ACC6B0.409@garzik.org>
Date: Mon, 2 Mar 2009 22:44:40 -0800
Message-ID: <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus' tree"
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 9:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Luis R. Rodriguez wrote:
>>
>> While extending the documentation for submitting Linux wireless bug
>> reports [1] we note the stable series policy on patches -- that of
>> having an equivalent fix already in Linus' tree. I find this
>> documented in Documentation/stable_kernel_rules.txt but I'm curious if
>> there is any other resource which documents this or elaborates on this
>> a bit more. I often tell people about this rule or push _really_ hard
>> on testing "upstream" but some people tend to not understand. I think
>> that elaborating a little on this can help and will hopefully create
>> more awareness around the importance of trees like Stephen's
>> linux-next tree.
>
> Just have people google for GregKH's copious messages, telling people a fix
> needs to be upstream before it goes into -stable.
>
> Typically you make things easy by emailing stable@kernel.org with a commit
> id.
>
> There are only two exceptions:
> * fix is upstream, but needs to be modified for -stable
> * fix is not needed at all in upstream, but -stable still needs it

This certainly helps, I'm also looking for good arguments to support
the reasoning behind the policy so that not only will people follow
this to help development but _understand_ it and so that they can
themselves promote things like linux-next and realize why its so
important. Mind you -- upstream for us in wireless for example is not
Linus its John's tree so what we promote is not to get the fix first
into Linus' tree but first into John's tree. Which is obvious to
developers but perhaps not to others.

Let me try:

Our "equivalent fix" policy exists to ensure the next kernel release
doesn't suck more, only less. We do this by ensuring every single
patch that goes into any stable kernel is already applied on the tree
used to release the next kernel release. As an consequence of this
policy we also tend to create more exposure and create better focus to
the different development trees that lead to Linus's tree thereby
making the distributed development model we depend on more apparent
and better structured.

  Luis
