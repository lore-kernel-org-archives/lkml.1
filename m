Return-Path: <linux-kernel-owner+w=401wt.eu-S1030835AbXDJPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030835AbXDJPjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030868AbXDJPjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:39:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:21030 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030835AbXDJPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NS22rS7IkbsugeapmJXW6boS3N8L/rdLKxE7xETOqEvXQ45Ia+hxlUxxnoxcoKBjd92qEajsQ3C1EFKxuSiVaWgVHtashqvoj/PLbyBxPKIhjwJWhdyTJ3bY8o4ieCzBmWv3gYLptBhmP1EHTSELJHO/F1At/2hdJOWmxVD27nM=
Message-ID: <d120d5000704100839s47d07ff1gc47ce9ea97d54002@mail.gmail.com>
Date: Tue, 10 Apr 2007 11:39:21 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: usb touchscreen breakage in 2.6.21-rc5-mm4 ?
Cc: "Helge Hafting" <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <461B9DFF.9080704@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070407005458.GA18985@aitel.hist.no>
	 <200704062237.13118.dtor@insightbb.com>
	 <20070409223643.GB2198@aitel.hist.no>
	 <200704092230.04144.dtor@insightbb.com>
	 <461B9DFF.9080704@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> Dmitry Torokhov wrote:
> > Hmm, I am concerned because not only you don't have an input device created,
> > you don't even see the driver being registered with usbcore. Could you please
> > try booting with debug_initcall to see with what error code usbtouchscreen
> > initialization fails?
> >
> Here is the dmesg from a boot with debug_initcall.
> I can't see any messages from usbtouchscreen.
> For me, it looks like the touchscreen is discovered and then
> nothing happens to it.
>

*sigh* When will I learn to spell names of kernel parameters
correctly? It is initcall_debug, not debug_initcall :( Could you try
again, please?

-- 
Dmitry
