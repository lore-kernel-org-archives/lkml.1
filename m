Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbYAVG57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbYAVG57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 01:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYAVG5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 01:57:52 -0500
Received: from hs-out-0708.google.com ([64.233.178.249]:5405 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753139AbYAVG5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 01:57:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pNQkMYNVUNkIhoGb5qnGz4BCzkO8S6thIfDQ9U4koehpbEsntYNh4ApvonSV1D4eGeFe3nFeaUATz6Wz8rkk6mkq3W8ncjHFoawOzqH/bYI2lnuwf4QA5ghRwBezwFVM/22sgKo3nPiGLloWr65MmZvali5lIWbM6S/IbE/HkpE=
Message-ID: <a8e1da0801212257j41f7535aj1fb8fc6cb0d7e048@mail.gmail.com>
Date: Tue, 22 Jan 2008 14:57:50 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 6/6] spi : use class iteration api
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
In-Reply-To: <200801212256.11484.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080112095711.GF2893@darkstar.te-china.tietoenator.com>
	 <20080122060331.GG3066@darkstar.te-china.tietoenator.com>
	 <200801212256.11484.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 2:56 PM, David Brownell <david-b@pacbell.net> wrote:
> On Monday 21 January 2008, Dave Young wrote:
> > +static int __spi_master_match(struct device *dev, void *data)
> > +{
> > +struct spi_master *m;
> > +u16 *bus_num = (u16 *)data;
>
> That's "void *data" so "u16 *bus_num = data" is preferred.
>
Fine.
