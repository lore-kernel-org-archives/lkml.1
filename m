Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXKVT5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXKVT5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 14:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbXKVT5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 14:57:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58008 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbXKVT5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 14:57:12 -0500
Date: Thu, 22 Nov 2007 19:54:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why is FIBMAP ioctl root only?
Message-ID: <20071122195451.35548d64@the-village.bc.nu>
In-Reply-To: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
References: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2007 19:17:14 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hi,
> 
>   I guess subject says it all - why is FIBMAP ioctl restricted only to
> root (CAP_SYS_RAWIO)? Corresponding ioctl for XFS is allowed without any
> special capabilities so we are inconsistent here too...
>   Would anyone mind if the check is removed?

It would be great if it was but it involves a *lot* of work.

Alan
