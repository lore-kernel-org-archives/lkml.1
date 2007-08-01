Return-Path: <linux-kernel-owner+w=401wt.eu-S1764789AbXHANDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764789AbXHANDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761987AbXHANCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:02:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53411 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761767AbXHANCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:02:55 -0400
Date: Wed, 1 Aug 2007 14:10:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Whats the problem with my IDE...
Message-ID: <20070801141013.365339f0@the-village.bc.nu>
In-Reply-To: <f8pmen$3vj$1@sea.gmane.org>
References: <f8mvg9$rc8$1@sea.gmane.org>
	<20070731104945.4411c85b@the-village.bc.nu>
	<f8pmen$3vj$1@sea.gmane.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I still have those messages, but now there seem to be much less of them.
> 
> It would really help me, if someone could tell me about how critical 
> such error messages are.

The CRC errors are indicative of cable or similar problems but each time
you see a CRC error the transmission is repeated so it should never cause
corruption. If there are repeated CRC errors it will give up and use PIO
instead.

> With the "slimmed down" kernel of slackware, which even needs an initrd 
> for ext2 root devices, I don't get this errors, so currently I only get 
> them while installing and not while my daily work on my system...

Could be one driver is upsetting another, or perhaps triggering more
hardware which in turn triggers this. You'd really need to know what the
extra driver which triggers the problem is ?
