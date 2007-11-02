Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbXKBEX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbXKBEX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 00:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbXKBEXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 00:23:20 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:54918 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbXKBEXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 00:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RtqblYhFSLX66+vOGpqSg6RdeVwxmGwO4chLRGCiJZ7Vd4sIYR9LRaIcTXfYgvqhGmG6Iy3/9rR1DOBe+0L3wgdAz5/H4J5ybcgm3B1lXSJaMWD7af2KdsUzkXl/+q8e8M4KTmyoL/Id7GEplTWnxsf5ectvSeIOgAo/DZiE6IM=
Message-ID: <a901b49a0711012123q3c553bc5q4db5ad900b5aad34@mail.gmail.com>
Date: Fri, 2 Nov 2007 09:53:18 +0530
From: "pradeep singh" <pradeep.rautela@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.23] Unable to boot kernel, regression?
Cc: linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071010190418.GA3589@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a901b49a0710092316y1c662846ne29e0f8ac3cbdba1@mail.gmail.com>
	 <20071010190418.GA3589@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Ingo Molnar <mingo@elte.hu> wrote:
[snip]
> >
> > Did something got changes which i forgot to take care of? or am i
> > missing something pretty obvious here?
>
> i have successfully built and booted a config derived from your config,
> on similar hardware. The only change is that i switched on some drivers
> by default and turned off some - the modified config is attached. Could
> you try this modified config, does it boot fine for you? (One crutial
> difference is that it uses CONFIG_SATA/PATA instead of CONFIG_IDE, so
> you might have to change /dev/hdax to /dev/sdax in your /etc/grub.conf,
> for the entry of the _new_ kernel only - if your system is not fs-label
> based.)

Sorry for the late reply Ingo. Did not get a chance to check mails.
Anyway i tried your config and with a little additional tweaking it works great.

Thanks for the help Ingo.

Best Regards
-- 
Pradeep
