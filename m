Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbXGMVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbXGMVEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 17:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXGMVE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 17:04:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:17354 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbXGMVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 17:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CgLONrj8GV+tBBSJQQLtVMwJJoSQr6ZW48yetJq9wJW5PEwMIcgZ2jMM706jwY2wbw+y0BNDzkICL98uBymbQ6sgYItuKAneHMC6rO31bp0dH1lF++TiLkW7+xSQIDGsHOnzemAGY7sF8d3x+L5x/LA0B2lTNOHjXP8t16BcYPo=
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: keyboard stopped working after de9ce703c6b807b1dfef5942df4f2fadd0fdb67a
Date: Fri, 13 Jul 2007 23:04:30 +0200
User-Agent: KMail/1.9.5
Cc: Dmitry Torokhov <dtor@insightbb.com>
References: <200707132249.26106.christophpfister@gmail.com>
In-Reply-To: <200707132249.26106.christophpfister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707132304.30795.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 13. Juli 2007 22:49 schrieb Christoph Pfister:
> Hi,
>
> After a kernel update I recognised that my keyboard sometimes didn't work
> after booting up. I found out that the issue appeared quite reliably after
> a cold reboot and not pressing any key (for example not selecting stuff at
> the bootloader) till the machine fully booted up.
> Because git head (4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4) didn't solve
> the problem I did a bisect and your commit was found to be the culprit (the
> second last build succeeded 5 of 5 times during my tests and the last build
> failed 2 of 3 times).
>
> Can anybody please shade light on this?
>
> Thanks,
>
> Christoph

Forgot to mention dmesg: "input: AT Translated Set 2 keyboard 
as /class/input/input0" is shown in both (working / failing) cases (no 
additional / related lines nearby).

Christoph
