Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab0BBR7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:59:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47000 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756109Ab0BBR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:59:53 -0500
Date: Tue, 2 Feb 2010 18:00:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] move host drivers for VLB IDE controllers to
 staging/out
Message-ID: <20100202180041.3fe575f8@lxorguk.ukuu.org.uk>
In-Reply-To: <20100202172708.7599.51937.sendpatchset@localhost>
References: <20100202172701.7599.2028.sendpatchset@localhost>
	<20100202172708.7599.51937.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Feb 2010 18:27:08 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] move host drivers for VLB IDE controllers to staging/out
> 
> - they are for really old hardware that nobody has any longer
> - they all require 'magic' parameters to work
> - many controllers are also supported by pata_legacy driver
> 
> so move them to staging/out and schedule for removal in 2.6.36
> unless somebody steps in to work on them.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>

When I actually tried some of the VLB bits while working on the
pata_legacy stuff it was clear these hadn't been maintained/used for a
very long time indeed. Most of them also are hacks doing stuff like fixed
mode settings.

However if the point of the old IDE code was as claimed to keep it as a
'stable' layer throwing chunks of it out doesn't strike me as in keeping
with the stated plan ...

Alan
