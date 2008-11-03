Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYKCXFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYKCXFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 18:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYKCXFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 18:05:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:31555 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKCXFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 18:05:42 -0500
Message-ID: <ac3eb2510811031505s38c1519ck83f5d89c68566da8@mail.gmail.com>
Date: Tue, 4 Nov 2008 00:05:35 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: edac: struct device - replace bus_id with dev_name(), dev_set_name()
Cc: dougthompson@xmission.com, linux-kernel@vger.kernel.org, greg@kroah.com
In-Reply-To: <20081103145733.3b1701d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225327145.5970.30.camel@nga.site>
	 <20081103145733.3b1701d1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 23:57, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 30 Oct 2008 01:39:05 +0100
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> Subject: edac: struct device - replace bus_id with dev_name(), dev_set_name()
>
> um,
>
> ERROR: space required after that ',' (ctx:VxV)
> #40: FILE: drivers/edac/edac_mc.c:404:
> +               "%s (%s) %s %s already assigned %d\n",dev_name( p->dev),
>                                                     ^
>
> ERROR: space prohibited after that open parenthesis '('
> #40: FILE: drivers/edac/edac_mc.c:404:
> +               "%s (%s) %s %s already assigned %d\n",dev_name( p->dev),
>
>
> where did this crap come from?  It looks like some automated thing
> placed a space at the wrong end of the string?
>
> If so, are we about to send hundreds of such mistakes into the tree?

It was me feeling automated, maybe 4 am in the morning.
It's only one instance in the ~60 patches I have so far:
  $ cat * | wc -l
  7255

  $ grep '( ' *
  bus_id-edac.patch:+		"%s (%s) %s %s already assigned %d\n",dev_name( p->dev),

Sorry for that.

Thanks,
Kay
