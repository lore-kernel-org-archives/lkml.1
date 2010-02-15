Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0BOItt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:49:49 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61274 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0BOItn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:49:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jxGOoPCp2wCMks+XFygZNaHMof6svu7xUkR6PwESbXx5/KXUpZ4FykdDkQo3zFmtIY
         GDpQ/KDopOQaDvD/xrNfBP00SSCSfaPRugrGYwRRK69ikK7taOgD36BbBIDdq1nH69Ix
         3otsW/XlspZYEn9/MDd7/OsU68rKzafq5oX3I=
MIME-Version: 1.0
In-Reply-To: <dc6d3181002142029j13a9e57la45aa90a269404fa@mail.gmail.com>
References: <dc6d3181002122148v6451ebffka164de288738485d@mail.gmail.com>
	 <63386a3d1002130548y7c839072y85097a9bcdf66cad@mail.gmail.com>
	 <4B76D8AE.7040102@jic23.retrosnub.co.uk>
	 <63386a3d1002131320u5afbc35ak2bc3533aab3f1e54@mail.gmail.com>
	 <dc6d3181002142029j13a9e57la45aa90a269404fa@mail.gmail.com>
Date: Mon, 15 Feb 2010 17:49:41 +0900
Message-ID: <1b68c6791002150049v60c21c3cha9ac12014355dfec@mail.gmail.com>
Subject: Re: [spi-devel-general] SPI-ADC
From: jassi brar <jassisinghbrar@gmail.com>
To: arjun rath <rath.arjun@gmail.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       spi-devel-general@lists.sourceforge.net,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 1:29 PM, arjun rath <rath.arjun@gmail.com> wrote:
> Let us try and see .If any body is having a reference driver for SPI based
> ADC,they can share.
Don't think you need to anything 'ADC specific' all u need is to _use_
your SPI driver.
grep for spi_sync in linux/drivers/ and refer to any spi user driver.
