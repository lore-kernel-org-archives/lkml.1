Return-Path: <linux-kernel-owner+w=401wt.eu-S1946628AbXBIQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946628AbXBIQwy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:52:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946636AbXBIQwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:52:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:3033 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946628AbXBIQww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:52:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f+RtKXRXPqJlRvaZO3sW1hUY+NrO+9jdN/4omyl52ACs9DJNwmJXpqDaFetRzJKPBbPgVe6F+kkiWKhroDU40XhzPehfjgAPAHdjT7HBi/lQtq5XdOJQINAYzupNcZGkmrzfLPAXs1X8g5/msW7XVOHgNzxEECBSCQpRlnk4zos=
Message-ID: <9e0cf0bf0702090852g273e254dj71e06c9133cffd0c@mail.gmail.com>
Date: Fri, 9 Feb 2007 18:52:51 +0200
From: "Alon Bar-Lev" <alon.barlev@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 01/34] __initdata cleanup - alpha
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, rth@twiddle.net
In-Reply-To: <45CCA58C.90604@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702091711.34441.alon.barlev@gmail.com>
	 <200702091713.23091.alon.barlev@gmail.com> <45CCA58C.90604@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > -static char __initdata command_line[COMMAND_LINE_SIZE];
> > +static char __initdata command_line[COMMAND_LINE_SIZE] = "";
>
> Why is this "= 0" to static global variables needed?

Please review http://lkml.org/lkml/2007/1/22/267

Best Regards,
Alon Bar-Lev.
