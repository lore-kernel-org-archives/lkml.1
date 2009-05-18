Return-Path: <linux-kernel-owner+w=401wt.eu-S1756324AbZERPp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbZERPp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZERPpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:45:19 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:56361 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZERPpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:45:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=AzJSRY3n1UHElCMjPZUua50z8eZAfdBz8zAYZ1DIQCapcx0Y1f8tEvbYcDxJWVhoRT
         OMjYns6fLy5leQBBhyoF4NktjPrLH9wgGrlwZnvN8S3bFhHS5M1B8JR/z/7wZQphSQK1
         UlXaf0DgULsZF0Prs1cLtNUxcl8/yYk8mC38U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/6] drivers/ide Convert printk(KERN_<foo> to pr_<foo>(
Date: Mon, 18 May 2009 17:48:40 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <cover.1242609803.git.joe@perches.com> <200905181612.43632.bzolnier@gmail.com> <1242661288.1572.82.camel@Joe-Laptop.home>
In-Reply-To: <1242661288.1572.82.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905181748.41172.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009 17:41:28 Joe Perches wrote:
> On Mon, 2009-05-18 at 16:12 +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 18 May 2009 04:21:08 Joe Perches wrote:
> > > Mostly mechanical conversion of printk's
> > Hmm.. less mechanical conversion using also dev_*() macros where suitable
> > would be much better...
> > How's about fixing pr_devel() which currently doesn't seem to be used
> > by anything inside kernel to not depend on DEBUG in separate pre-patch
> > and then using it instead of pr_debug()?
> 
> How about deferring the "printk(KERN_DEBUG" to something else
> and doing the mechanical conversion to core as a first pass,
> followed by core pr_<foo> to dev_<foo> where appropriate
> as a second pass?

Fine with me.

> What do you think is appropriate for pr_<foo> to dev_<foo>
> conversions?

printk()s using drive->name or hwif->name

Thanks,
Bart
