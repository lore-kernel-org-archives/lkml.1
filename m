Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYKKA4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYKKA4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 19:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYKKA4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 19:56:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYKKA4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 19:56:06 -0500
Date: Mon, 10 Nov 2008 16:55:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: tim.gardner@canonical.com
Cc: tcanonical@tpi.com, bryan.stillwell@hp.com, Mike.Miller@hp.com,
       iss_storagedev@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: firmware version is invalid
Message-Id: <20081110165558.428566ab.akpm@linux-foundation.org>
In-Reply-To: <49144CB8.8070604@tpi.com>
References: <20081106201204.9C2AEF8A65@sepang.rtg.net>
	<1226005890.13433.390.camel@aki.stillwell>
	<49144CB8.8070604@tpi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 07:12:08 -0700
Tim Gardner <tcanonical@tpi.com> wrote:

> Stillwell, Bryan wrote:
> > Tim,
> > 
> > Thanks for getting this merged, but I believe this patch is preferred
> > over the original one I attached:
> > 
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
> > 
> > The reason for this according to Mike Miller is: "The first fix could be
> > called anytime something changed on the controller such as number of
> > logical volumes, etc.  This patch will get called only once for each
> > controller."
> > 
> > Thanks,
> > Bryan
> 
> applied
> 

I'm all confused here.

cciss-fix-regression-firmware-not-displayed-in-procfs-again-and-again.patch
is now in mainline.  Are you saying that "cciss: Firmware Version is
invalid" is preferred?  That "cciss: Firmware Version is invalid"
should still be applied?

If so, "cciss: Firmware Version is invalid" will need a better title
and changelog, please.  The one you have there is pretty skimpy. 
reading between the lines, I'm guessing that the driver emits "Firmware
Version is invalid" messages and that this patch somehow fixes that?

