Return-Path: <linux-kernel-owner+w=401wt.eu-S1752332AbYKXI5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbYKXI5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYKXI5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:57:04 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:10940 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYKXI5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:57:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NxyZLt4t66Kmkc8tR4+aDvESWFpVAw4kvwzUk46N4ax9Nk6dngFfdvhEK58WJwa3YH
         0svRjSZYAnyvM8xT07KzKfi2n+OoZmdfQKwZfxvOdKGcHMTjeXA/cwD0XP8Jtw5hVyRl
         Uy3yxI2spxjssSKvtnKLg2PeqTQAdm0V/ieXM=
Message-ID: <b637ec0b0811240057n3bc9f3f1i42b4fc94173f8f3@mail.gmail.com>
Date: Mon, 24 Nov 2008 09:57:01 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jay Fenlason" <fenlason@redhat.com>
In-Reply-To: <492A5557.2010404@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0811230817x5b445a0m665305d2b6bf6c1f@mail.gmail.com>
	 <b637ec0b0811231024t73d1b8b3x9e23e24dda94c6b8@mail.gmail.com>
	 <b637ec0b0811231223r2032f221geeb19ea5804d3b91@mail.gmail.com>
	 <200811240031.55944.rjw@sisk.pl> <492A5557.2010404@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Nov 24, 2008 at 8:18 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
>
> The commit which was pointed to in the bisection does nothing else than
> free some data in firewire-core.
>
> (Note to myself and Jay:  See http://lkml.org/lkml/2008/11/23/123 and
> http://lkml.org/lkml/2008/11/23/153 for the history of this bug.)
>
> Fabio, please test a _bad_ kernel with firewire drivers unloaded before
> hibernation.

That's what I'm already doing right now.

> Also, please enable in the "Kernel hacking" kernel config
> menu:  "Kernel debugging", "Debug slab memory allocations".  Thanks,

Will do. Thanks

> --
> Stefan Richter
> -=====-==--- =-== ==---
> http://arcgraph.de/sr/
>

Regards,
Fabio
