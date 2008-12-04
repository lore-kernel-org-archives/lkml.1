Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbYLDOCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbYLDOCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYLDOBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:01:52 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:6427 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbYLDOBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HvmsTSPvRrLqA64PbLZQGb75PTzRmjcrusIfruIeexRZlti02ogilMen8i6upkx7ID
         /m4LIHAs5TYW5ICngHju+7q8KxlZQEt+m6qP8aml5zbyZr8M/Ud+bDm13YKPzooHcR5o
         3ZF42kkinBQ2jgQEsAHLBCeFzpUDmpEmM0fIg=
Message-ID: <b2b2f2320812040601k55ab69a6n5da4d321151f94f@mail.gmail.com>
Date: Thu, 4 Dec 2008 08:01:49 -0600
From: "Shane McDonald" <mcdonald.shane@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Resurrect IT8172 IDE controller driver
Cc: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081204100717.32819f1b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1L4UpB-0007ro-1g@localhost> <492A8306.9000400@ru.mvista.com>
	 <b2b2f2320812031839q43eb6102jbae0fbddd9a1cf75@mail.gmail.com>
	 <20081204100717.32819f1b@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would it be acceptable to claim that these changes are outside the
scope of this patch, and code the IT8172 driver to behave in the same
manner as the other wrong drivers, with a suitable comment indicating
this fact?

Shane

On Thu, Dec 4, 2008 at 4:07 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I am not sure how to determine if IORDY sampling is supported by a
>> drive.  If I'm reading the code correctly, other drivers only check
>> that the PIO mode is > 2 (not > 1 as in my driver) -- that seems to be
>> the case for at least piix.c, siimage.c, and it8213.c.
>
> Old IDE is wrong on this and in fact unless it has changed recently
> simply can't cope with and doesn't provide functions for it. A libata
> driver can use the libata helpers but those also rely on the core ata
> code doing certain things so if you cut and paste it over you might have
> to make other old IDE changes in parallel.
>
>
