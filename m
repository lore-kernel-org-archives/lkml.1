Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbYGOAxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbYGOAxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 20:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757882AbYGOAxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 20:53:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:27810 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbYGOAxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 20:53:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XZfNsMTiuOV6oscHTpPj0EfBVk47jTC04N8NNrbqr9Pe6NcBpRC9rmFXL1rS9PBSea
         qsO803kSU/UYHorQBi3OfBfY6FKO1kA+kicLXBjFBLTVKg1wnNQKbgeTdZU4mHJMcKJD
         5AtYoUkm1hXVm7fCnW5HZLU6C/I3Q5KCEUQls=
Message-ID: <86802c440807141753x36884fe8v5f6306b3dc8fd9a7@mail.gmail.com>
Date: Mon, 14 Jul 2008 17:53:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <1216083125.27455.125.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <20080714164119.99c33d5b.akpm@linux-foundation.org>
	 <1216079223.27455.92.camel@shinybook.infradead.org>
	 <86802c440807141653s22b91c72gadd6f51ea4a477a@mail.gmail.com>
	 <1216081404.27455.97.camel@shinybook.infradead.org>
	 <86802c440807141750m937c824kf37c5adf490c8e4a@mail.gmail.com>
	 <1216083125.27455.125.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 5:52 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Mon, 2008-07-14 at 17:50 -0700, Yinghai Lu wrote:
>>   MK_FW   firmware/tigon/tg3.bin.gen.S
>> make[1]: *** No rule to make target `firmware/tigon/tg3.bin', needed
>> by `firmware/tigon/tg3.bin.gen.o'.  Stop.
>> make: *** [firmware] Error 2
>
> I didn't include the tg3 patch in what I just asked Linus to pull. Are
> you working from linux-next?

linus tree.

YH
