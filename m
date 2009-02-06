Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbZBFR4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbZBFR4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760645AbZBFR4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:56:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40080 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760488AbZBFR4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:56:17 -0500
Date: Fri, 6 Feb 2009 17:56:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] Resume from hibernation fails with pata_it821x
 RAID volume
Message-ID: <20090206175635.5344ce37@lxorguk.ukuu.org.uk>
In-Reply-To: <498C778B.7020309@ru.mvista.com>
References: <200902061412.09839.linux@rainbow-software.org>
	<498C778B.7020309@ru.mvista.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     See CodingStyle chapter 8 for the preferred multiline comment style.
> 
> > +		memset(&id[ATA_ID_SERNO], 0x20, ATA_ID_SERNO_LEN);
> 
>     Why not ' '?
> 
> MBR, Sergei


Digging into the docs the RAID serial number (and what that means isn't
defined anywhere I can see) is byte offset 54-73 in each of the 4 128
byte blocks returned by the chip status query we do at boot
(it821x_probe_firmware).

Alan
