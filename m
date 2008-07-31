Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYGaOHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYGaOHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYGaOGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:06:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57019 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYGaOGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:06:42 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200807311531.18377.rjw@sisk.pl>
Subject: Re: [bug] 2.6.27-rc1: I/O errors after resume
References: <200807281203.38822.j.schneider@uib.de> <20080730011223.8f04ba20.akpm@linux-foundation.org> <E1KOXpA-00005w-Vl@pomaz-ex.szeredi.hu> <200807311531.18377.rjw@sisk.pl>
Message-Id: <E1KOYng-0000FR-Cr@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 31 Jul 2008 16:06:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Rafael J. Wysocki wrote:
> On Thursday, 31 of July 2008, Miklos Szeredi wrote:
> > With 2.6.27-rc1 things break badly after resume on my T60.  Dmesg and
> > config attached.  2.6.26 worked fine.
> 
> Ugh, lots of stuff in a single message.

Yeah, sorry.  Search for "I/O error" for the interesting parts.

> Anyway, can you try the current -git and report back, please?  It's possible
> that this has been fixed already.

Not fixed:

mszeredi@tucsk:~> uname -a
Linux tucsk 2.6.27-rc1-00156-g94ad374 #17 SMP Thu Jul 31 15:45:10 CEST 2008 x86_64 x86_64 x86_64 GNU/Linux
mszeredi@tucsk:~> dmesg
bash: /bin/dmesg: Input/output error

Seems easily reproducible, so if no better ideas I can try to bisect
it.

Miklos
