Return-Path: <linux-kernel-owner+w=401wt.eu-S1161115AbXDNGv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115AbXDNGv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161121AbXDNGv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:51:28 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:51035 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161115AbXDNGv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:51:27 -0400
Message-ID: <462079ED.2000605@gmail.com>
Date: Sat, 14 Apr 2007 08:51:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: MOXA: mxser_new lockup
References: <20070414042725.GT20376@fi.muni.cz>
In-Reply-To: <20070414042725.GT20376@fi.muni.cz>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kasprzak napsal(a):
> 	Hello,

Hello.

> I have a MOXA C168H card, and after the upgrade from 2.6.19 to 2.6.21-rc6
> (and from moxa.c to mxser_new.c) I get a system lockup after few seconds
> of communicating over the MOXA serial line. Noting is printed on the
> serial console at all. The system is SMP x86_64 (Fedora 5). I may be
> able to do a limited testing on request, but the system is in production
> use most of the time. For now, I will probably move back to the older
> driver.
> 
> 	Are you aware of any SMP or 64-bit issues in mxser_new.c?

No :(. I went through the locking again just now, but I can't see anything
wrong. Could you please enable CONFIG_PROVE_LOCKING and CONFIG_DEBUG_LOCKDEP and
retest?

And also post stty -a -F /dev/ttyMIXX or a setup passed to
tcsetattr/ioctl(TCSETA/S) if available. What do you use for communication?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
