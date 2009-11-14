Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbZKNCzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbZKNCzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 21:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZKNCzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 21:55:04 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:51261 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZKNCzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 21:55:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=N9E+v+DQcCX/IPHbQRBzuXonnEoMM2PzT9AxX93sEhhGI+qeaXHzOz9/WyIYXwwhEs
         wJkxHzajy/fJGzLbxLVqB+mbmn3Ieo0lX7GIHmQqZpudLKREtab4Bd4tOm95FupYFjUT
         K/41vN44C+AxyOFrm7dR5JqZbNBNVZgcvS6bY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Sat, 14 Nov 2009 03:54:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Jonathan Corbet <corbet@lwn.net>
References: <4AFCC0D4.9020708@gmail.com> <200911140046.29450.bzolnier@gmail.com> <20091114022951.GA9796@srcf.ucam.org>
In-Reply-To: <20091114022951.GA9796@srcf.ucam.org>
MIME-Version: 1.0
Message-Id: <200911140354.01808.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009 03:29:51 Matthew Garrett wrote:
> On Sat, Nov 14, 2009 at 12:46:29AM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> > Skipping the technical merit of the quoted text for the moment -- I find
> > the fact that you keep calling the present IDE host drivers (that many
> > developers helped to fix) as "old" ones or "buggy" ones rather degrading
> > for their (this includes me of course) hard work.
> 
> Without making any judgement about the relative quality of the drivers 
> in their role as IDE drivers, the fact that ACPI hotplug works with 
> libata and doesn't work with drivers/ide means that, rationally, 
> distributions need to use the libata stack for the more common parts. 

This doesn't change the fact that there are real regressions present in
libata host drivers and people who should be responsible for fixing them
are just ignoring them..

> There simply isn't the same level of integration between drivers/ide and 
> the rest of the OS.

Fully agreed but it doesn't change anything for issues discussed.

On the side note -- certain distributions, I'm sure you know which one
I mean specifically [1],  "helped" a lot in making sure that such level
of integration would be very difficult to achieve (ACPI hotplug was
added later than some distributions, again you know which one I mean
specifically [1], switched to libata _only_ for PATA).

[1] The one whose developers love to blame every damn single problem
on everybody else from PC hardware designers ;) through BIOS' writers
to ordinary users..  instead (if only from time to time) considering
that there could be something wrong with their own development process
if they constantly miss fixes done by their competitors..

-- 
Bartlomiej Zolnierkiewicz
