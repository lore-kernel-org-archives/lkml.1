Return-Path: <linux-kernel-owner+w=401wt.eu-S965445AbXCGNi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965445AbXCGNi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965468AbXCGNi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:38:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:12499 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965445AbXCGNi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:38:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R21YnHPX/ns/kh04P0tlbN/a/Clnv9zVCet3GQe/W9aNQ2cd6yvBgf58W4GY9S3rMwpT92/R19W67OImP3foHAzvfMljOR2HjVG6ao+631AvrlhX59pwQsQVc7I2FcdslOROpU5BmqA3T9cRE90ej/cSNF6/Ef0YtdJGtnIWOMs=
Message-ID: <57354eff0703070538l1a4ed170q6eb8dd8bbf7aadf0@mail.gmail.com>
Date: Wed, 7 Mar 2007 14:38:25 +0100
From: "Oleksiy Kebkal" <kebkal@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, rmk@arm.linux.org.uk,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
In-Reply-To: <m3irddusp0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	 <m3bqj6jebt.fsf@maximus.localdomain>
	 <200703061824.08834.rgetz@blackfin.uclinux.org>
	 <m3irddusp0.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/7, Krzysztof Halasa <khc@pm.waw.pl>:
> Robin Getz <rgetz@blackfin.uclinux.org> writes:
>
> > It is useful on (broken) legacy serial equipment, where RTS should be
> > completely under the applications control.
> >
> > Glitches on RTS aren't acceptable, and confuse some devices.
>
> Does that mean you can't use TIOCMSET, TIOCM_RTS etc?

No. It is possible to use TIOCMSET only after open syscall. Between
open and ioctl syscals RTS will be asserted. Sometimes it is not
acceptable behaviour.

-Oleksiy
