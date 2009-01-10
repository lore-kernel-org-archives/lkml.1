Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZAJN4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZAJN4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbZAJN4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:56:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42508 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751747AbZAJN4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:56:09 -0500
Date: Sat, 10 Jan 2009 13:55:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110135508.3d54007f@lxorguk.ukuu.org.uk>
In-Reply-To: <49689C38.1040607@ru.mvista.com>
References: <200901091334.55823.borntraeger@de.ibm.com>
	<200901101009.13699.borntraeger@de.ibm.com>
	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	<200901101242.05203.borntraeger@de.ibm.com>
	<49688B63.5030105@ru.mvista.com>
	<20090110122130.318cf168@lxorguk.ukuu.org.uk>
	<49689C38.1040607@ru.mvista.com>
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

On Sat, 10 Jan 2009 16:01:44 +0300
Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Hello.
> 
> Alan Cox wrote:
> 
> >>   That's the typical REQUEST SENSE command with 18-byte data length.
> 
> > Which means something has become horribly broken in the core libata stack.
> > An 18 byte inquiry would have 18 bytes as the *last* sg element. That
> 
>     Did you get me right? 18 bytes is the typical REQUEST SENSE payload 
> (libata requested 96 bytes), not INQUIRY. For the INQUIRY 36 bytes was 
> requested and received (divisible by 4).
>     And I doubt there can be more than one S/G segment with such lengths...

I am quite sure there cannot be - however the WARN clearly shows that we
got passed one.
