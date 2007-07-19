Return-Path: <linux-kernel-owner+w=401wt.eu-S940969AbXGSR6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940969AbXGSR6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762936AbXGSR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:58:33 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:56385 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbXGSR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:58:32 -0400
Message-ID: <469FA5E5.3070301@gmail.com>
Date: Thu, 19 Jul 2007 19:56:53 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
References: <20070716161539.075822000@pademelon.sonytel.be>	<20070716162206.529280000@pademelon.sonytel.be>	<20070718164351.a92ec032.akpm@linux-foundation.org>	<Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>	<20070719021752.35cb7daa.akpm@linux-foundation.org>	<Pine.LNX.4.62.0707191137470.8661@pademelon.sonytel.be> <20070719024730.03609f1f.akpm@linux-foundation.org>
In-Reply-To: <20070719024730.03609f1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2007 11:47 AM, Andrew Morton wrote:

> On Thu, 19 Jul 2007 11:39:32 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
>>> Oh dear.
>>>
>>> 	ps3rom_priv(dev) = host;
>>>
>>> that's 'orrid.  We have an identifier pretending to be a function, only we
>>> go and treat it as an lvalue.
>>>
>>> I mean, C code should look like C code, and the above just doesn't.
>>>
>>> Sigh.

You could insist that it be PS3ROM_PRIV() because then it at least also 
_looks_ like cpp...

Rene.
