Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbZERQlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbZERQlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZERQlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:41:16 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:41398 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbZERQlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:41:16 -0400
Date: Mon, 18 May 2009 18:40:35 +0200
From: Martin Lottermoser <Martin.Lottermoser@t-online.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090518164034.GA7789@wanza.invalid>
References: <20090517091224.GA8280@wanza.invalid> <4A10509C.603@gmail.com> <200905172135.10136.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905172135.10136.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ID: ThqnUTZCwhNk9T8qPSZqBv1HTxmd8DbJOH4b4uNQAZ8xYCnV+EuYmpvTEVNeU0bQVR
X-TOI-MSGID: 4e4ed561-a88d-4f66-8047-9dd57a3221be
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 17, 2009 at 09:35:09PM +0200, Bartlomiej Zolnierkiewicz wrote:
> * try 2.6.30-rc6 (maybe 2.6.29.3 oops has been fixed already and we just
>   need to backport it)

I've done that and put the resulting files again on the web at:

  http://home.vrweb.de/martin.lottermoser/linux/

The files are named "2.6.30-rc6-*".

The basic result is that the kernel still panics, still in
drivers/ide/ide-io.c, the final output on the real console shows only
a call stack (far deeper than with 2.6.29.3) but no terminating panic
message, and the ouput sent through netconsole arrives truncated.

Regards,
Martin Lottermoser
--
Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
Greifswaldstrasse 28
38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
Germany
