Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbXE3QTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbXE3QTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbXE3QTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:19:15 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:47897 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbXE3QTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HGmn/KV8zZCVb8AiO67EYVJ8URTagbY91MivcnpRgKt/ocdkDiXfqR5YIRG2bb+hDI5zC6iQxVeS+hPof017G8LDRH3+3c+wg2160IFizts36XJ9YT+oZJucjNlnFk75Hcnd4h4TOWJ0s71zJwSbloHX4lW3wKcghksYQMMBF84=
Message-ID: <a781481a0705300912j4dc7776cjc50707cffd8a0cbf@mail.gmail.com>
Date: Wed, 30 May 2007 21:42:23 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Artem Bityutskiy" <dedekind@yandex.ru>
Subject: Re: JFFS2 using 'private' zlib header (was [RFC] LZO de/compression support - take 6)
Cc: "Daniel Hazelton" <dhazelton@enter.net>,
       "Michael-Luke Jones" <mlj28@cam.ac.uk>,
       lkml <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       "Mark Adler" <madler@alumni.caltech.edu>, jloup@gzip.org
In-Reply-To: <465D9C62.4070009@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4cefeab80705280734i37df1742k6738cd4200813684@mail.gmail.com>
	 <a781481a0705290427n3bad472aqf4e0b8276780b405@mail.gmail.com>
	 <231C137C-D0BF-44F7-B2D5-AE610284D00A@cam.ac.uk>
	 <200705290943.11176.dhazelton@enter.net>
	 <a781481a0705290815y32758055te52cb8657f34acc@mail.gmail.com>
	 <465D7EFB.8090609@yandex.ru> <465D9C62.4070009@yandex.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On 5/30/07, Artem Bityutskiy <dedekind@yandex.ru> wrote:
> Err, and important note is that it also wants this compressed data to be
> independently uncompressable.

Hmm, okay.

But what I meant was that if jffs2's needs are "standard" enough in
the sense that they could conceivably be required by other users too
(and this one mentioned by you does appear to be one of those),
then why not make such hacks (if they are necessary and suitable
indeed, lets wait for Mark's response) part of zlib itself?

Thanks,
Satyam
