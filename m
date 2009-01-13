Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbZAMNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbZAMNp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZAMNpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:45:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53192 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753241AbZAMNpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:45:08 -0500
Date: Tue, 13 Jan 2009 13:45:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz, tytso@mit.edu
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090113134503.41318144@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz>
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

> Plus it has a nasty behaviour where it reverts to -W1 if disk
> connection is momentarily lost. (If you unplug/replug SATA disk, linux
> will happily rediscover and use it, but -W0 was already forgotten at
> that point, right?)

If you momentarily lose power your disk state isn't defined anyway. If
you do that with the SATA code it should treat it the same as a scsi disk
swap so it'll get a new device and the old fs will go down.
