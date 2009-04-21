Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZDURiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZDURiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbZDURhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:37:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45092 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZDURhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:37:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=X8onI6VNRFn8fI55H8HBjnSC3LaLRgftChOJIiEC+WPKgCi/G29HpU4OcDuJTUbL+
	saiquxsm8h+GAWr3Hlk6Q==
MIME-Version: 1.0
In-Reply-To: <20090421032728.GA14175@kroah.com>
References: <88cc3e770904201826odfde9baodcf8c221a0296909@mail.gmail.com>
	 <20090421032728.GA14175@kroah.com>
Date: Tue, 21 Apr 2009 10:37:41 -0700
Message-ID: <88cc3e770904211037p497fddb8x780b787987d4812@mail.gmail.com>
Subject: Re: [stable] question regarding the -stable patch queue ?
From: Abhijit Karmarkar <awk@google.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 8:27 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Apr 20, 2009 at 06:26:53PM -0700, Abhijit Karmarkar wrote:
>> hi,
>>
>> i am trying to find if a particular upstream commit [1] will appear in
>> the next -stable release of 2.6.28 kernel.
>
> Yes it will.

nice.

>
>> i see this commit being marked as "-stable candidate". does that mean
>> it will automatically make it to the next stable release?
>
> Yes.
>

good to know that.

>> or should i submit a patch against the latest 2.6.28 stable series, to
>> have this patch queued up for next stable release (2.6.28.10). can
>> someone please advice?
>
> If you know that the commit that went into Linus's tree will not apply
> to the 2.6.28-stable tree, please send an updated version to the
> stable@kernel.org address.
>

this particular upstream commit
(01522df346f846906eaf6ca57148641476209909) applies cleanly to
2.6.28-stable and fixes the panic.

>> what is the recommend way to do this search ("will upstream patch X be
>> included in the next stable release")? so i don't bug this list in
>> future with similar queries.
>
> Just ask stable@kernel.org about it.  We've been a bit behind on
> flushing out the -stable queue (right now my todo-stable mbox contains
> 399 emails I need to wade through), due to vacations and conferences.
> I'm slowly getting there, sorry for the delay.
>

no worries. thanks for maintaining the -stable series :-) looking
forward to 28.10

thanks
abhijit


> thanks for your patience,
>
> greg k-h
>
