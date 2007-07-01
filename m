Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXGARdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXGARdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 13:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbXGARdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 13:33:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:4870 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbXGARdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 13:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XwP9aXnwnCBbOx6zhoEbCqTn0z7AiN6VJfE4wBFlwnwS5SgRnRwxd1aGbTG53Izq1Jac+W/RDKMwFuM4UPL3zcaBF/VdDFbs+RsO9RIZy6LercCf6X0iaT+dl32uv9U6mUu4yZGT8dgTiVSb5FPEYGSOAG+33AKtfUpZsd24WOA=
Message-ID: <2c0942db0707011033v21c91584h3924402f0ce30fa5@mail.gmail.com>
Date: Sun, 1 Jul 2007 10:33:12 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: Dan <metalifloyd@gmail.com>
Subject: Re: PROBLEM: SATA AHCI driver significant throughput loss in 2.6.22-rc5-g75154f40-dirty
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <439fa30707010956h1c467e28xc9eff37ebec523ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <439fa30706262117u2d5553dfp8395c6ca41574a8c@mail.gmail.com>
	 <20070630005747.9bc9ba40.akpm@linux-foundation.org>
	 <439fa30707010956h1c467e28xc9eff37ebec523ad@mail.gmail.com>
X-Google-Sender-Auth: 1f4cf95616adc7d9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/1/07, Dan <metalifloyd@gmail.com> wrote:
> > Are you able (as a matter of some urgency) to run a git bisection
> > search to identify the offending commit?
>
> For some reason I am no longer able to reproduce the problem. I've
> tried several versions including the one I reported and I just can't
> reproduce the problem. I accidentally overwrote the original kernel
> that had the problem. The weird thing is even when I reset the git
> tree to 2.6.22-rc5-g75154f40 and build it, the error is gone.

But that isn't the kernel you reported the error against. You reported
that 2.6.22-rc5-g75154f40-*dirty* had the error, which means there was
a diff between what you were building and what was in the repository.
If you know what the diff was and it was something trivial, then you
can disregard this bit of pedantry, but if not, try to recall if you
had something else patched against that.

Regardless, as it's not reproducible it sounds like the report should
be closed...
