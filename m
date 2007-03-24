Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXCXMEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXCXMEv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 08:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXCXMEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 08:04:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:51890 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXCXMEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 08:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a3iRF/n5zOU1hhNeMX+8LZyYlkTbCA32eP/b42pykdQPe/pybyPZ4JTEdakE2w50Qd+MAquY7Z+vi6z8MC06pC0aZxB6f5VVwcxD+FYtOv8YHBIRyx45Dafn4DEs7IIFQxcLriyhZ/9djXEhpdhcQoH72atEfFqdrDsa6I3Li6E=
Message-ID: <1a297b360703240504u2c9e705m5601d150f15e3c45@mail.gmail.com>
Date: Sat, 24 Mar 2007 16:04:46 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] DVB: Delete unused header file linux/dvb/version.h.
Cc: "Marcel Siegert" <mws@linuxtv.org>, "Andrew Morton" <akpm@osdl.org>,
       v4l-dvb-maintainer@linuxtv.org,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1174665764.1158.241.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703231130480.30201@CPE00045a9c397f-CM001225dbafb6>
	 <200703231647.53780.mws@linuxtv.org>
	 <1174665764.1158.241.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 2007-03-23 at 16:47 +0100, Marcel Siegert wrote:
> > On Friday 23 March 2007, Robert P. J. Day wrote:
> > >
> > > Delete the unreferenced header file include/linux/dvb/version.h.
> > >
> > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > >
> > NACK
> > this header is unreferenced in kernel, but used for applications that compile for userspace
> > to determine the api version.
>
>
> btw that is something extremely evil to do. Either you have varying apis
> between kernels (which is naughty, but I suppose you can go up in
> capabilities) or it's fully static.
>


There are cases where we need an API update since newer systems do show up.
In such a case, the only way is to provide backward compatibility
while adding in newer stuff.

Currently we use the version major/minor for the userspace to identify
the in kernel API, while the userspace apps can remain binary
compatible



Regards,
Manu
