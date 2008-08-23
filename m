Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYHWXZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYHWXZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 19:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYHWXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 19:24:52 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:41967 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYHWXYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 19:24:51 -0400
From: Chr <chunkeey@web.de>
To: Sergey Spiridonov <sena@hurd.homeunix.org>
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363  (JMB363) kernel 2.6.25-2 Debian/Lenny
Date: Sun, 24 Aug 2008 01:27:51 +0200
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc4; KDE/4.1.0; x86_64; ; )
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org>
In-Reply-To: <48B0916C.4080805@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808240127.51972.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+GbGJYEzMMfGwigcKaaE614OC6LZIq8r66IrTZ
	qV/7nkkOsGWkkvtSSUg1ETNRY091+OBJbtJ/p8zN67AEmrpc5J
	5/D4dpr34=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 August 2008 00:38:36 Jeff Garzik wrote:
> See http://ata.wiki.kernel.org/index.php/Libata_error_messages for an
> introduction.
>
> In general, tons of ATA bus errors and SError register bits means that
> problems are coming from the ATA bus, a.k.a. the SATA cable and its
> related connections.
>
> So...  suspect bad cables, bad port connectors, cable interference,
> motherboard-caused interference or grounding problems, power supply
> problems.
>
hmm, or something totally odd...

what happens if you do: (after you made a backup!)
"dd if=/dev/sdX(where X is your affected hdd?) of=/dev/null bs=1"
Note:
The important bit is the small bs (blocksize) number.
You can throw in a O_DIRECT flag to disable the caches, or 
if you have some "empty" partition space, you can "dd" into
it with a small blocksize too)

my seagate & even a samsung hd103uj doesn't like that and will spew
out the same sort problems you have just posted... (but they work fine,
if I don't do nasty dd things!)

and unfortunatly my md(raid1) seems to do lots of "small" reads & writes
when it starts to check/resync the whole 1TB array :-/.

Regards,
	Chr
