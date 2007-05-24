Return-Path: <linux-kernel-owner+w=401wt.eu-S1761076AbXEXIBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076AbXEXIBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 04:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbXEXIBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 04:01:24 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:15083 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbXEXIBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 04:01:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bK/U9pO4VbgZlgMvTZsJt93E6Kflc+OAlaW01NhEyawK9PyopfpjM+Zw/gfE4xfJWTisIIQkj1Jbjb5vJLBXxIxEVQB5ppOFpEP5YFAk773ll+5q5qygMldNiZzolmasRwhEmGAfOREivDIOBn9sBxtKvf8N9+xCz1ya1xckKrk=
Message-ID: <5486cca80705240101u2fb6a954q53025752560f3ef7@mail.gmail.com>
Date: Thu, 24 May 2007 10:01:21 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: "Romano Giannetti" <romano.giannetti@gmail.com>
Subject: Re: 2.6.21.1 fails to suspend/resume to disk (sort of)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1179914262.7043.56.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179905115.7043.25.camel@localhost>
	 <200705231105.08408.rjw@sisk.pl> <1179914262.7043.56.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2007/5/23, Romano Giannetti <romano.giannetti@gmail.com>:
[cut]
> Uf, I will try to find the time. I am on my way to try to compile
> 2.6.21.2 now. Problem is that a kernel compile "the ubuntu way" last
> hours here. If there is an expert on make-kpkg here, I could use some
> advise. I'd prefer to test patches over a 2.6.21 stable release, to
> avoid mixing symptoms from an experimental -rc...

Is not the ubuntu or debian way to take hours to compile. Is that you
have to trim the config and enable the only modules you need for your
hardware, then a rebuild cycle could last 10-15 min.

You will spend one hour once to cut down the configuration, but then
you can reuse the .config for new kernels too with make oldconfig.

To find the minimum configuration for you hardware use lspci -v,
menuconfig help, and look at chapter 7 and 8 of Linux Kernel in a
Nutshell:

http://www.kroah.com/lkn/

Also, pasting "lspci -n" output in the following page can be of some help:

http://kmuto.jp/debian/hcl/

Hope this helps.

> Romano

    ~ Antonio
