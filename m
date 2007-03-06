Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXCFKUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXCFKUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCFKUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:20:40 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:63326 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbXCFKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:20:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r1gKZR4ii070243833tqdR2d8xJmQZSndmnb2Zk1VodBq/MJZEqNEBbbkd5DIo3sNILQifSAhs1U+ITxfbIQW2IAo2V1/e/JakxjcJC85+gtWUGd03MNVPo1pztvK8e4nxuO4+AtuQOXNiMhQoAMj3PThqFZePyo+h54ThKTCKk=
Message-ID: <c0a09e5c0703060220l18246d19kd1645a16067d1b3d@mail.gmail.com>
Date: Tue, 6 Mar 2007 02:20:37 -0800
From: "Andrew Grover" <andy.grover@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH 1/3] libata: add missing PM callbacks
Cc: "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070306082212.GC2040@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070302083001.GK20322@htj.dyndns.org>
	 <45E8B3C8.2090009@garzik.org> <45E8E749.4030406@gmail.com>
	 <20070306080509.GA2040@elf.ucw.cz> <45ED22AB.4090901@gmail.com>
	 <20070306082212.GC2040@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Pavel Machek <pavel@ucw.cz> wrote:
> > 1. drop !CONFIG_PM configuration
> > 2. continue to sprinkle #ifdef's over device drivers
> > 3. find out prettier way to mark PM functions
>
> ...of 3., and code is nicely generic and fairly simple. I thought it
> would be too much work to implemente it, and it would get too messy.
>
> Given that it is so simple, I believe 3. is the best option. We can
> still do 1. in future if we feel like so...

How much room does it actually save? And, can we maybe have some
actual embedded people saying they need this special treatment?

-- Andy
