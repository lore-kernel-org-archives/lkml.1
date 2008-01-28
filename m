Return-Path: <linux-kernel-owner+w=401wt.eu-S1754558AbYA1JFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbYA1JFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYA1JEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:04:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:13772 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYA1JEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JcmPK8sA8OW5nGLBOP4cfHrH3ROWZ+r3+GqBqA+k6nnBUQ7ioDAsvRi88dHoaf8veOYm/ibsug79qNERZq7C/aj+jaLPHklXzb1D6J0e5kRTVfcWVhrSj+w7E+/5to3Tuyu7ADtfeo2brQlhVW+PTHDrvOGT912iUtEOuCetyWw=
Message-ID: <479D9AA7.8080107@gmail.com>
Date: Mon, 28 Jan 2008 10:04:39 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Question about DMA
References: <38b2ab8a0801271251v1a9ea256w8fa4b9fcc620f742@mail.gmail.com>	 <479D06E0.3090601@gmail.com> <38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
In-Reply-To: <38b2ab8a0801280055j6d1d235boe79e6aea058f8f96@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2008 09:55 AM, Francis Moreau wrote:
> No ;)

Heh :)

> My DMA controller has very little in common with ISA DMA one. But I'd like to
> use it in a driver. This driver can do DMA but with the help of an external DMA
> controller. It's only implement the "slave" side. So basically this driver needs
> to configure one of the DMAC channels before transfering data.

Which bus is it in this case?

> What other API could I use in this case ? I don't think the DMA-mapping can
> help in this case...
