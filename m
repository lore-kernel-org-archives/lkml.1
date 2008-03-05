Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYCEPBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYCEPBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYCEPBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:01:22 -0500
Received: from ip32-53-209-87.adsl2.versatel.nl ([87.209.53.32]:58541 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752397AbYCEPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:01:21 -0500
X-Greylist: delayed 9725 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 10:01:20 EST
Date: Wed, 5 Mar 2008 11:56:10 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it
 means."
Message-ID: <20080305115610.397b3ea3@the-village.bc.nu>
In-Reply-To: <20080304173058.7679b7c8.akpm@linux-foundation.org>
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	<200803050234.40594.bzolnier@gmail.com>
	<20080304173058.7679b7c8.akpm@linux-foundation.org>
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


> I didn't know any of that.  The changelog might have been kinda fun, but
> given that it failed to tell us that the patch fixes data-corruption
> errors, the changelog was excrutiatingly bad.

I have no reason/evidence to believe it fixes data corruption errors of
any kind. For the specific combinations of device it should simply avoid
a long pause, complaints and a switch to lower speeds.

The ATA disk case with serverworks (which is a potential corruptor) was
always correctly handled.
