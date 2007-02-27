Return-Path: <linux-kernel-owner+w=401wt.eu-S1750810AbXB0MbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750810AbXB0MbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 07:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXB0MbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 07:31:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:50905 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbXB0MbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 07:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GOXL+IskvEREiuNXcT7Dw7sx+4hfRrZMZJJATwIhZVKAlYr6cPQjEeQpONYUZa/Z/U1kemlQEn6jNiX4zUVsp/EX1HI04Am26Yadov0I9kwtfyhobIcVYC1Qb/186ow/AuTrKTI0KwitAuRO4xYnKjkOAnnp43w2uuZ8hG+q31o=
Message-ID: <f19298770702270431i198e032fhe025e221a625140f@mail.gmail.com>
Date: Tue, 27 Feb 2007 15:31:20 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Kyle McMartin" <kyle@mcmartin.ca>
Subject: Re: ioread32 endianess.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070226160450.GB3787@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770702260736i51622584r1979a202bdc64c1d@mail.gmail.com>
	 <20070226160450.GB3787@athena.road.mcmartin.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/26/07, Kyle McMartin <kyle@mcmartin.ca> wrote:
> On Mon, Feb 26, 2007 at 06:36:05PM +0300, Alexey Zaytsev wrote:
> > Hello.
> >
> > May I ask you, guys, if ioread32 and his friends should treat the data
> > as host-endian or bus-endian? E.g, should the data read from PCI on a
> > big-endian host be byte swapped or not?
> >
>
> It should be in bus-endian. This is why ioreadXbe() exist.

Than how should one write a portable endian-independent driver? Should
I wrap ioread32 with an le32_to_cpu?

>
> Cheers,
>         Kyle
>
