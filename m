Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbZCXCHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbZCXCHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 22:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZCXCHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 22:07:32 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:47987 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbZCXCHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 22:07:31 -0400
Message-ID: <49C84060.6010903@mnementh.co.uk>
Date: Tue, 24 Mar 2009 02:07:28 +0000
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>	 <20090316193010.56644165@mjolnir.ossman.eu> <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>
In-Reply-To: <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm wrote:

> Thanks for your help. I was hoping on getting patch 3 and 4 included
> in 2.6.30 as well if possible. I suspect that i have to rework them a
> bit first though. That's no problem. Just let me know how you guys
> prefer things and i'll resend.

Can you clarify how your platform actually controls the MMC clock? does 
it at all?

what is your platform?

Ideally, the MMC code would use the clock API for some of this, but I 
seem to remember there were issues with this (cant recall what right now 
and its 2:05 AM).
