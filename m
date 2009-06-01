Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZFAMed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZFAMed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZFAMeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:34:25 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:46128 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbZFAMeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:34:24 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: ttyACM0: 2.6.30-rc7 dies on device disconnect, strange echo (regressions)
Date: Mon, 1 Jun 2009 14:34:56 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.30-rc7-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090601101421.GA1914@elf.ucw.cz> <200906011242.06244.oliver@neukum.org> <20090601113151.GB2445@elf.ucw.cz>
In-Reply-To: <20090601113151.GB2445@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906011434.57083.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 1. Juni 2009 13:31:51 schrieb Pavel Machek:
> Steps to reproduce:
>
> minicom /dev/ttyACM0
>
> Bug #2: try to interactivelly communicate with the other
> device. Notice that characters are echoed one character too late. You
> type "hello", but only "hell" appears. You press "!", "o" appears.
>
> Bug #1: while minicom is still connected, pull the USB cable. Machine
> locks hard.

I can replicate neither bug with 2.6.30-rc7. Can you replicate it with
anything but openMOKO?

	Regards
		Oliver

