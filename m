Return-Path: <linux-kernel-owner+w=401wt.eu-S965146AbXHHRgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146AbXHHRgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760230AbXHHRfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:35:48 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43784
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbXHHRfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:35:47 -0400
Subject: Re: Serial buffer memory leak
From: Paul Fulghum <paulkf@microgate.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070808163217.2f59fe84@the-village.bc.nu>
References: <200708081158.06843.laurentp@cse-semaphore.com>
	 <20070808144532.5e3a1998@the-village.bc.nu>
	 <1186582307.3394.3.camel@x2.microgate.com>
	 <200708081628.36897.laurentp@cse-semaphore.com>
	 <1186584775.3508.13.camel@x2.microgate.com>
	 <20070808161606.32a40793@the-village.bc.nu>
	 <20070808163217.2f59fe84@the-village.bc.nu>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 12:35:37 -0500
Message-Id: <1186594537.3413.7.camel@x2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 16:32 +0100, Alan Cox wrote:

> Ok try this for size folks. Use tty->flags bits for the flush status.
> Wait for the flag to clear again before returning
> Fix the doc error noted
> Fix flush of empty queue leaving stale flushpending
> 
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

It looks good and clean.

I compiled and tested the patch with interleaved
tcflush() and read() calls, allowing random amounts
of receive data to accumulate between each call.

Acked-by: Paul Fulghum <paulkf@microgate.com>

Thanks,
Paul

--
Paul Fulghum
Microgate Systems, Ltd

