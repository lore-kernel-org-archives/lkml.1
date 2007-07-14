Return-Path: <linux-kernel-owner+w=401wt.eu-S1765638AbXGNVFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765638AbXGNVFZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 17:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762762AbXGNVFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 17:05:10 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:62814 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763986AbXGNVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 17:05:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RI76pUt11lAk5vR4xMqz2uBxs9S/XItE961JJIrFg6PDY0Hp3AEUJesIvPs7ObJcWLZOnAPNdc1luHgvgJ3Mm9TYfaUWHGQiw0UkuZHXEXsbJtRkUlrtwpbpPcPaOFs2OEr7ngD/98q32ORJ7A3NfNE3xVUm4ZZe+Vxjov4BN8o=
Message-ID: <76366b180707141405n7aeb9cf0i6d66ca5b0093bd8f@mail.gmail.com>
Date: Sat, 14 Jul 2007 17:05:07 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Geode GX framebuffer driver: Arcom vs. AMD
Cc: linux-kernel@vger.kernel.org, "Jordan Crouse" <jordan.crouse@amd.com>
In-Reply-To: <1184445094.4692.2.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180707141201u14585c2eyeb58f0b7b279ea1b@mail.gmail.com>
	 <1184445094.4692.2.camel@daplas>
X-Google-Sender-Auth: c59bb5879e31e047
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

Do you have the patch working already? I'd love to try this out in the
meantime on the LX system I am developing with at the moment. I'm
assuming you worked this into the existing Arcom framework (gxfb) and
pulled the necessary pieces from the AMD code?

I looked at doing this, but it just seemed easier to use the AMD
provided driver, as it would be easier to merge any changes in the
future and might provide more full support for the hardware and all
its modes.

Also, question for AMD/Jordan.. Is AMD going to provide any
support/patches for the existing gxfb and this new lxfb? (Maybe
perhaps an AMD supported DirectFB driver? :))

If anyone else is interested, I'll get around to making a patch of the
work I just did to bring the original AMD 2.6.11 framebuffer &
Cimarron fully up to date with the 2.6.22 tree. If AMD is going to
continue to maintain their own driver, this will allow the use of an
up-to-date kernel.

Thanks, -Andrew

On 7/14/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> There's a patch for the AMD Geode LX which I'm going to send for the -mm
> tree soon. Its module name is lxfb.
>
> Tony
