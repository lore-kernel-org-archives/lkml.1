Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZDOIln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZDOIln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZDOIlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:41:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38777 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751927AbZDOIlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:41:31 -0400
Date: Wed, 15 Apr 2009 09:40:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415094039.3ff3ff2e@lxorguk.ukuu.org.uk>
In-Reply-To: <49E546C4.1060001@garzik.org>
References: <49E4FAC6.1030400@garzik.org>
	<20090414183807.3baf72ed@infradead.org>
	<49E546C4.1060001@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If this change added an implicit initramfs requirement, that is a pretty 
> major regression.

USB root has always needed an initramfs. On some boxes it might happen to
work most of the time because of other implicit delays. You were just
lucky in the past.

If you are so initramfs averse you could try hacking the kernel to try
remounting the root every few seconds for a bit if it fails rather than
giving up.

Alan


