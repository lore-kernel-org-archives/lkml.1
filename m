Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYAWHpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYAWHpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 02:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYAWHo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 02:44:58 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:19070 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYAWHo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 02:44:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IvCG+C4y4N9G405c4CtlevbZV0sxPAbrrnxVRQ0i2yNE7k0Z4e1979NcTz1YKxetD8WfhjvLMfUtPTQznY6KIVDvPh3cLeBumsFPUOG5LVMS29zJhGlBJrQhb+G1UHtrnNhoNkYk4w5HBGcFfMkb+hHtBZ9bMkpp3Nx273usuRc=
Message-ID: <a8e1da0801222344l101c2b90s363821c26bc8cb55@mail.gmail.com>
Date: Wed, 23 Jan 2008 15:44:54 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: 2.6.24-rc8-mm1 : net tcp_input.c warnings
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0801230937270.31652@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <a8e1da0801220109v6bf8931ev50f2210402c3ba41@mail.gmail.com>
	 <Pine.LNX.4.64.0801221115150.31652@kivilampi-30.cs.helsinki.fi>
	 <a8e1da0801221744m37021e88h5c188e5b31ea42bf@mail.gmail.com>
	 <20080122.190137.206066966.davem@davemloft.net>
	 <Pine.LNX.4.64.0801230937270.31652@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23, 2008 3:41 PM, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
>
> On Tue, 22 Jan 2008, David Miller wrote:
>
> > From: "Dave Young" <hidave.darkstar@gmail.com>
> > Date: Wed, 23 Jan 2008 09:44:30 +0800
> >
> > > On Jan 22, 2008 6:47 PM, Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> > > > [PATCH] [TCP]: debug S+L
> > >
> > > Thanks, If there's new findings I will let you know.
> >
> > Thanks for helping with this bug Dave.
>
> I noticed btw that there thing might (is likely to) spuriously trigger at
> WARN_ON(sacked != tp->sacked_out); because those won't be equal when SACK
> is not enabled. If that does happen too often, I send a fixed patch for
> it, yet, the fact that I print print tp->rx_opt.sack_ok allows
> identification of those cases already as it's zero when SACK is not
> enabled.
>
> Just ask if you need the updated debug patch.

Thanks,  please send, I would like to get it.

>
> --
>  i.
