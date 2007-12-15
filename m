Return-Path: <linux-kernel-owner+w=401wt.eu-S1760493AbXLOEjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493AbXLOEjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXLOEj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:39:27 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:11774 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXLOEj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:39:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=u+TmgK6tAm3VKtPqKVr+UAt15KERYJHxy4899EsLpMAEdmTswsZfxWNlZ55DYF/mp2nBdYcnqJa6iCRtS4S6EK6wsZXUSipPTcfW1vDX5oxOly1yk2DeUK4MqMQZVNYb0j+IZgfzgiFNgH5ZUR4p9l7xkiUfYfj/MBJJMibmLs4=
Message-ID: <f17812d70712142039wa4655cu999dc9d3b9bd49ea@mail.gmail.com>
Date: Sat, 15 Dec 2007 12:39:25 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 0/2] gpiolib: add support for PCA9539
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       i2c@lm-sensors.org, "David Brownell" <david-b@pacbell.net>
In-Reply-To: <20071214171646.0fe5a876@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70712100137h3aa0056bq78b0efb92d072891@mail.gmail.com>
	 <20071214171646.0fe5a876@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean,

I'd like to postpone the corresponding change to the point that
polling i2c patch is merged.

On Dec 15, 2007 12:16 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Eric,
>
>
> On Mon, 10 Dec 2007 17:37:05 +0800, eric miao wrote:
> > Support for PCA9539 as a GPIO chip is separated into two patches:
> >
> > 0001 - gpiolib: basic support for 16-bit PCA9539 GPIO expander
> > 0002 - gpiolib: add Generic IRQ support for 16-bit PCA9539 GPIO expander
> >
> > the 2nd one uses workqueue for IRQ handling due to the interrupt mode
> > nature of the i2c-core, thus making it a separate patch.
>
> Note that the situation could change according to the discussion in
> this thread:
> http://lists.lm-sensors.org/pipermail/i2c/2007-December/002378.html
>
> --
> Jean Delvare
>



-- 
Cheers
- eric
