Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbXGIPxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbXGIPxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 11:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbXGIPwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:52:55 -0400
Received: from mailgw1.fraunhofer.de ([153.96.1.18]:52517 "EHLO
	mailgw1.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbXGIPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:52:54 -0400
Date: Mon, 09 Jul 2007 17:50:41 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: linux-kernel@vger.kernel.org
Subject: Re: cdparanoia not setting count and/or reply_len properly
Message-ID: <46925951.rhmTy3qJyl09MRxP%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jul 2007 15:52:52.0063 (UTC) FILETIME=[34F73EF0:01C7C241]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> It is probably about time that cdparanoia was updated ...

>    I think the same, but given that it works, Monty probably doesn't
>have much motivation to update it. I don't know if the problem resides
>in the cdparanoia program itself (so using the DAE problem from cdrkit
>will fix the issue) or in the paranoia library. In this case, the
>problem will affect any program using the library.

Do not try to replace one dead program by another one....

If you like actively maintained software you need to look here:

ftp://ftp.berlios.de/pub/cdrecord/alpha/

http://cdrecord.berlios.de/new/private/cdrecord.html

The main problem with cdparanoia is that it is based on a 10 year old cdda2wav.
Even if Monty did start working on it again, he would not change that.

Sending bad SCSI commands is a result of bad low level code from an 
extremely old cdda2wav version.

Libparanoia in cdrtools is based on the assets of the cdparanoia program.
The software has been made portable and several bugs have been removed by me.

BYW: The next plan with cdda2wav is to add C2-pointer support and to allow
libparanoia to know whether a sector was bad or not even if a bad sector
will re-read the same for every try. This will make cdda2wav behave better
with extremely bad/scratched media.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
