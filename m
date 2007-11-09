Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXKIBoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXKIBoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbXKIBoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:44:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.227]:53241 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbXKIBon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:44:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Iv99SPsB/obFPlcH+jaZPpg4JrFSNYojXeopCE+1pKuYYLupPUy+8PfLXSZLNYf+JQ5TJJPu1uEHvYUTsUuCwAgTXlcbwRkj7ydd61YNaZtTKIO02pUUf+rFMGC3Ii0BfPF062zym1aVEjGxRSJqw+WpRKsYGPlFDoSUsmfX738=
Message-ID: <4733BB7F.8010004@gmail.com>
Date: Fri, 09 Nov 2007 10:44:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Denys Fedoryshchenko <denys@visp.net.lb>
CC: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <liml@rtr.ca>,
       James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
References: <20071101213013.M54162@visp.net.lb> <20071107232045.GA26706@havoc.gtf.org> <20071107235548.M95675@visp.net.lb> <200711080130.54143.bzolnier@gmail.com> <20071108071204.M66693@visp.net.lb> <20071108104813.78ca4d65@the-village.bc.nu> <20071108164320.M82021@visp.net.lb> <20071108173139.GA1932@havoc.gtf.org> <20071108195605.M20599@visp.net.lb>
In-Reply-To: <20071108195605.M20599@visp.net.lb>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Fedoryshchenko wrote:
> Thanks, it works like that.
> 
> Seems in libata there is no fall-back to non-DMA mode, if DMA didn't work.

There is, it's just too conservative about that.  With improvements
pending for 2.6.24, it should be quite snappy at falling back to PIO if
configured transfer mode doesn't seem to work at all (consecutive IO
command failures after transfer mode configuration change).

-- 
tejun
