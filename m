Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZEYWih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZEYWih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZEYWi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:38:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55188 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751715AbZEYWi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:38:28 -0400
Date: Mon, 25 May 2009 23:38:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jacob <fun2program8@yahoo.com>,
       Christopher Hogan <chris.c.hogan@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add warning about possible HPA compatibility
 issue
Message-ID: <20090525233814.4cb8b1c2@lxorguk.ukuu.org.uk>
In-Reply-To: <200905260036.17718.bzolnier@gmail.com>
References: <200905252348.08970.bzolnier@gmail.com>
	<20090525232014.7b6dd7bd@lxorguk.ukuu.org.uk>
	<200905260036.17718.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > NAK - this is extremely misleading and will just randomly terrify users,
> > who may then set the paramater and corrupt things like BIOS save areas.
> 
> Please propose better description.

As was discussed before

Tejun has a patch in the queue which exposes the HPA and real sizes to
the OS

Libata can support revalidating a disc

Once the HPA/Real size data is there the tools can be tuned for this and
a sysfs node added to switch hpa on/off per disc. At that point this can
be done by the user space intelligently.

The fact this is a user parameter is itself a problem.

