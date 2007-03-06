Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXCFMEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXCFMEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933249AbXCFMEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:04:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:4232 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbXCFMEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MBt4mnqfu5EoeKtf6rGGrxJvisYDXkKO53Nr0I0yPaXDaHbkDxpkwdZ6EgjZ0rMjWVxKp8ArEe92ksiLQmgoizNEmm0KhjYhxQx5xNW2UTbe2GeF2aePOiB4b8wths9vNp9g9bmgD0COcsRjY4hEcRqesVe61saXFEz3QPWe8i0=
Message-ID: <b6a2187b0703060403o48130853m9393df70160303c1@mail.gmail.com>
Date: Tue, 6 Mar 2007 20:03:58 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 1)
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>, linux-pm@lists.osdl.org,
       "Ingo Molnar" <mingo@elte.hu>, lenb@kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <b6a2187b0703051732v79a532f6mbf0d3da857a914e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <20070226220152.GA29575@stusta.de>
	 <20070228211318.GB4301@mellanox.co.il>
	 <b6a2187b0702281945n5f62a6b5w1c535de3ef9aaa8f@mail.gmail.com>
	 <20070305000421.GF3441@stusta.de>
	 <b6a2187b0703051732v79a532f6mbf0d3da857a914e6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> On 3/5/07, Adrian Bunk <bunk@stusta.de> wrote:
>
> > > I have the same problem on my IBM X60s on rc1 and rc2. Can't resume
> > > from RAM, can't suspend to disk. It is possible to revert all the
> > > changes to ACPI and test it?
> >
> > This is with CONFIG_KVM=n?
>
> Yes.

I've tried with CONFIG_KVM=n and CONFIG_KVM=y and both does not suspend.
