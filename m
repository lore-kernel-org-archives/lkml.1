Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbYBNM0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbYBNM0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbYBNMZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:25:54 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:37357 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755632AbYBNMZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:25:53 -0500
Message-ID: <47B433C8.3030301@i4.informatik.rwth-aachen.de>
Date: Thu, 14 Feb 2008 13:27:52 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Hans-Peter Jansen <hpj@urpla.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: strange SysRq problem
References: <200802140102.14252.hpj@urpla.net>
In-Reply-To: <200802140102.14252.hpj@urpla.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hans-Peter Jansen wrote:
> I'm suffering from a strange SysRq problem:
> 
> syslog shows haphazardly "SysRq : HELP" lines, while I definitely didn't 
> triggered them, neither via (PS/2) keyboard, nor via /proc/sysrq-trigger.
> This is accompanied with stalls of about 15-60 secs. 

Any chance that a device connected via serial (or an USB device which uses USB/Serial conversion)
triggers them? My cheap pl2303 device seems to send spurious BREAKs every once in a while, which
results in the described behavior, as the kernel will print the help line for any character which
is not a valid sysrq. (The probability to trigger another sysrq with random data is much lower, but
did you find any other printout of an sysrq in your logs?)

Best regards,
Arnd Hannemann



