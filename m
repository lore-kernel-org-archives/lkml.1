Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbZKYRX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbZKYRX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759260AbZKYRXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:23:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53897 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759320AbZKYRXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:23:52 -0500
Date: Wed, 25 Nov 2009 17:25:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/86] pata_atiixp: no need to program PIO timings for
 MWDMA
Message-ID: <20091125172558.69b37360@lxorguk.ukuu.org.uk>
In-Reply-To: <20091125170323.5446.6849.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125170323.5446.6849.sendpatchset@localhost>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 18:03:23 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_atiixp: no need to program PIO timings for MWDMA
> 
> Moreover the code to do it was buggy and programmed PIO timings
> even if they were already set to a desired values.
> 
> There shouldn't be any problems with it as IDE atiixp host driver
> has been allowing separate PIO/MWDMA timings for last two years.

I need to take a look at the history of this - it got put there for a
reason I am sure. Whether a right one I don't know. Needs running past
AMD/ATI's maintainer anyway who should know.


