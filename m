Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbYARKbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbYARKbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 05:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760088AbYARKbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 05:31:32 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:25723 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050AbYARKba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 05:31:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MmbC3Rg6EtdJ4A0cau8MNjWy5uHw8Y1XRAd3WMhZe9fOqW6GPWvQK9I51m31UQU+Kw7kLF0GcMIPG+JbisfFxrPYk4Ne+VECfIn0ttlL+6UkBy2eQvISeFQKZjwpZFx3wO8IzPmYGPWUbgpDeaoLUpeR8hNsDCN8LiwLJ8pasbc=
Message-ID: <4df4ef0c0801180231j46391b2byc38be709b3cbf2c8@mail.gmail.com>
Date: Fri, 18 Jan 2008 13:31:29 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH -v6 0/2] Fixing the issue with memory-mapped file times
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <E1JFnho-0008TH-5G@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12006091182260-git-send-email-salikhmetov@gmail.com>
	 <E1JFnho-0008TH-5G@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/18, Miklos Szeredi <miklos@szeredi.hu>:
> > 4. Performance test was done using the program available from the
> > following link:
> >
> > http://bugzilla.kernel.org/attachment.cgi?id=14493
> >
> > Result: the impact of the changes was negligible for files of a few
> > hundred megabytes.
>
> Could you also test with ext4 and post some numbers?  Afaik, ext4 uses
> nanosecond timestamps, so the time updating code would be exercised
> more during the page faults.
>
> What about performance impact on msync(MS_ASYNC)?  Could you please do
> some measurment of that as well?

I'll do the measurements for the MS_ASYNC case and for the Ext4 filesystem.

>
> Thanks,
> Miklos
>
>
