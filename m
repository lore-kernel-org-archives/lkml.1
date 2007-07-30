Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbXG3ORR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbXG3ORR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760620AbXG3ORG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:17:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbXG3ORF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:17:05 -0400
Message-ID: <46ADF2CB.4030200@zytor.com>
Date: Mon, 30 Jul 2007 07:16:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@yahoo.fr>
CC: Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc1, spamassassin vs rpc stuffs, rpc 1, spamassassin 0
References: <200707300957.39667.gene.heskett@gmail.com> <3d8471ca0707300704wc4119c2iaf865d685324d7c@mail.gmail.com>
In-Reply-To: <3d8471ca0707300704wc4119c2iaf865d685324d7c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guillaume Chazarain wrote:
>> Comments anyone?
> 
> This is not specific to the kernel.
> It was discussed here: http://lkml.org/lkml/2007/1/24/258
> http://cyberelk.net/tim/portreserve/ seems to be the solution,
> it's a pity it is not widely deployed.
> 

The better solution probably would have bindresvport() in glibc be aware 
of a blacklist.

	-hpa
