Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYGTTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYGTTTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 15:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYGTTS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 15:18:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53158 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYGTTS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 15:18:59 -0400
Date: Sun, 20 Jul 2008 19:46:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Simen Timian Thoresen <simentt@dolphinics.no>
Cc: linux-kernel@vger.kernel.org, Simen Thoresen <simentt@dolphinics.no>
Subject: Re: Misidentification and failing revalidations of ide dvd-roms
 with libata
Message-ID: <20080720194628.6c8632cb@the-village.bc.nu>
In-Reply-To: <48838593.8020007@dolphinics.no>
References: <48838593.8020007@dolphinics.no>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  155.457098] ata4.00: model number mismatch 'Pioneer DVD-ROM 
> ATAPIModel DVD-116  0109' != 'Pioïeer¡DVD­ROM¡ATAñIMoåel åVD-±16 ¡010¹'
> [  155.457103] ata4.00: revalidation failed (errno=-19)

So it failed because the data read from the drive was corrupted.

> As I understand, this would most commonly indicate that the drive has 
> gone bad, but this also occurs on the /other/ drive (same make/model) in 

Or a cable problem.
