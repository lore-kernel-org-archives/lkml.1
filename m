Return-Path: <linux-kernel-owner+w=401wt.eu-S1762937AbXFSSrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762937AbXFSSrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762110AbXFSSrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:47:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:11192 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762196AbXFSSrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JpVu+lAXCxU1cJPzI0YXTYU0fNFiQoPfY4HewHvoS/5NqK69fIA3Pc0LAHD2Iwdr6aGZGHg2ThJ1l4nvMdk6UQRnMOB6Pd/BA7OIZ+sDGj4vziOGgZHBLutDRht94aOHNLAQn+NqpvD0eVezaCirnvOu2xHIOJsq60p+xczV8zM=
Message-ID: <a781481a0706191147x72be6357vf0c83808b13174b8@mail.gmail.com>
Date: Wed, 20 Jun 2007 00:17:12 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Paulo Marques" <pmarques@grupopie.com>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
Cc: "Andrew Morton" <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Mike Frysinger" <vapier@gentoo.org>
In-Reply-To: <4678013C.5090402@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4678013C.5090402@grupopie.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/19/07, Paulo Marques <pmarques@grupopie.com> wrote:
>
> The only in-kernel user of "memmem" is scripts/kallsyms.c and it only
> uses it to find tokens that are 2 bytes in size. It is trivial to
> replace it with a simple function that finds 2-byte tokens.
>
> This should help users from systems that don't have the memmem GNU
> extension available.

So we could remove the "#define _GNU_SOURCE" at the top
of scripts/kallsyms.c too, presumably? If not (i.e. if there are
more GNUisms left in that file anyway), then I'm not sure if we
really gain by the change.

Satyam
