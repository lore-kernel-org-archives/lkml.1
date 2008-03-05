Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbYCEPDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbYCEPDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYCEPCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:02:54 -0500
Received: from ip32-53-209-87.adsl2.versatel.nl ([87.209.53.32]:58543 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756805AbYCEPCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:02:53 -0500
Date: Wed, 5 Mar 2008 14:39:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it
 means."
Message-ID: <20080305143949.1f56017c@the-village.bc.nu>
In-Reply-To: <200803051421.14167.bzolnier@gmail.com>
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	<20080304173058.7679b7c8.akpm@linux-foundation.org>
	<20080305115610.397b3ea3@the-village.bc.nu>
	<200803051421.14167.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is strange coincidence with being on the blacklist and FIFO corruption.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=433557
> 
> Bugzilla Bug 433557: Data corrupion with Fedora8 on HPT370 disk controller (Abit BX133 mobo)
> 
> IBM-DTLA-307030 is on the blacklist....

I wish it was more than a co-incidence but the trace shows it dropped
speed as expected.

> for OSB4 yes but...
> 
> /* Seagate Barracuda ATA IV Family drives in UDMA mode 5
>  * can overrun their FIFOs when used with the CSB5 */

Which gives you a CRC error according to my notes

Alan
