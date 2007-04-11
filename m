Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXDKOhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXDKOhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXDKOhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:37:17 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:62506 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXDKOhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=r1cWsOBmWsUC5I6ms078/q98xLHvUPXNgtDaP204NCvrQAmdPnUv0StniPbCZ+dgardSWd7Ep/7J5tsUypSsI5uBTiBNG3GX8oPVQbseCaeHibiOqazYDcbrpmat4H3KZ84tq+uoYoFCeGclCtIVY5cIxqVpTvCuDicnCMR5VO4=
Message-ID: <d120d5000704110737o2d74b734xfc5756eac9dbbc29@mail.gmail.com>
Date: Wed, 11 Apr 2007 10:37:11 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: usb touchscreen breakage in 2.6.21-rc5-mm4 ?
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
In-Reply-To: <461CAF73.3020201@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070407005458.GA18985@aitel.hist.no>
	 <200704062237.13118.dtor@insightbb.com>
	 <20070409223643.GB2198@aitel.hist.no>
	 <200704092230.04144.dtor@insightbb.com>
	 <461B9DFF.9080704@aitel.hist.no>
	 <d120d5000704100839s47d07ff1gc47ce9ea97d54002@mail.gmail.com>
	 <461CAF73.3020201@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> Dmitry Torokhov wrote:
> >
> > *sigh* When will I learn to spell names of kernel parameters
> > correctly? It is initcall_debug, not debug_initcall :( Could you try
> > again, please?
> Here is the dmesg for rc5mm4 with initcall_debug, showing how
> no usbtouch function is called at all.
>

Helge,

I don't have any explanation why we don't see usbtouch_init called at
all in -rc5-mm4. Could it be toolchain misbehaving? Do you see
references to usbtouch_init in the kernel image itself?

-- 
Dmitry
