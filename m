Return-Path: <linux-kernel-owner+w=401wt.eu-S966757AbZLHWXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966757AbZLHWXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966741AbZLHWXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:23:00 -0500
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:25872 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756398AbZLHWW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:22:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RFd3Qd+P1/J/WeczrHLffkJSCIIcxCsryYDGhJodrD5Kh0VThYK3KckL8RRnzsq82KnwjqtTur/qGSP9/OMKoCYRCqnhSWoykKAVm+IYRQITWLyjWBhUfCiR3WNfNL+KL2MoXo2xa6Y0rTp6L25n0fML2Oow9lYi6MVgdZTBVQE=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: yEa1YycVM1nJU9BAISM2km21oODlUrkGKOovK7hvFJIbWpNY6kh28Tnqf6lyAOdyUulX5IBNizUmUjbR9RZe5_0H0fCL1_noFRLvc_kmrCNqCnfd7FMYIQhIJHfK6ZXZRibJb1U.gf0y6pl6SwTKXsTXaZeHz0II0eaQTP1uNdnbxVjIBG4W55fals6_pbeGkj3jXGfu.f49FlqtMBidYNdzF59ngmKbXIPG6WDe7muH7kKe2Nj4ZMBMnJc_weFNDjM5GrYbJkaH3j9cCggzZLu5UcrTaTMtHF4lRBTA.TcwZBXLE173K2SHX9C5l4Zz
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 4/6] docs: correct gpio.txt typos
Date: Tue, 8 Dec 2009 14:23:05 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, "Dominik D. Geyer" <dominik.geyer@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <12601530441131@xenotime.net>
In-Reply-To: <12601530441131@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912081423.05173.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 December 2009, Randy Dunlap wrote:
> From: Dominik D. Geyer <dominik.geyer@gmx.de>
> Subject: correct gpio.txt typos
> 
> Corrected sysfs gpio chip node name and fixed punctuation.
> 
> Signed-off-by: Dominik D. Geyer <dominik.geyer@gmx.de>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

Ack.

> ---
>  Documentation/gpio.txt |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- lnx-2632-rc6.orig/Documentation/gpio.txt
> +++ lnx-2632-rc6/Documentation/gpio.txt
> @@ -380,7 +380,7 @@ rare; use gpiochip_remove() when it is u
>  
>  Most often a gpio_chip is part of an instance-specific structure with state
>  not exposed by the GPIO interfaces, such as addressing, power management,
> -and more.  Chips such as codecs will have complex non-GPIO state,
> +and more.  Chips such as codecs will have complex non-GPIO state.
>  
>  Any debugfs dump method should normally ignore signals which haven't been
>  requested as GPIOs.  They can use gpiochip_is_requested(), which returns
> @@ -531,7 +531,7 @@ and have the following read/write attrib
>  		This file exists only if the pin can be configured as an
>  		interrupt generating input pin.
>  
> -GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
> +GPIO controllers have paths like /sys/class/gpio/gpiochip42/ (for the
>  controller implementing GPIOs starting at #42) and have the following
>  read-only attributes:
>  
> 
> 
> -- 
> 
> 


