Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbYGZQTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbYGZQTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbYGZQTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:19:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44550 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754588AbYGZQTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:19:36 -0400
Date: Sat, 26 Jul 2008 17:01:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Introduce ata_id_has_unload()
Message-ID: <20080726170136.144f51b0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080726062142.29070.87751.stgit@denkblock.local>
References: <87prp1kvyy.fsf@denkblock.local>
	<20080726062142.29070.87751.stgit@denkblock.local>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 08:24:35 +0200
Elias Oltmanns <eo@nebensachen.de> wrote:

> Add a function to check an ATA device's id for head unload support as
> specified in ATA-7.

If a feature is new in ATA 7 you should also check the ATA version is >=7
in the tests. Just in case some prehistoric device has it down for a
different purpose.

Alan
