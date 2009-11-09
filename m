Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZKIXed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZKIXed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbZKIXec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:34:32 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:56562 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbZKIXeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:34:31 -0500
Date: Mon, 09 Nov 2009 22:59:42 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rt28x0: remove no longer needed common/cmm_data_2860.c
Message-ID: <50BD25B328%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <200911092106.32462.bzolnier@gmail.com>
References: <200911091720.39821.bzolnier@gmail.com> 
 <50BD09C528%linux@youmustbejoking.demon.co.uk> 
 <200911092106.32462.bzolnier@gmail.com>
Mail-Followup-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
 gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Messenger-Pro/2.60.0.3101 (Qt/4.5.3) (Linux-x86_64)
X-NuLabour-Date: Mon, 9110 Dec 1984 22:59:42 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Bartlomiej Zolnierkiewicz may or may not have written...

> On Monday 09 November 2009 18:54:38 Darren Salt wrote:
>> Your removal of cmm_data_2860.c also removes a bug fix (commit
>> 0af49167b1e5ba154e90d2c454bf4624ee47df80; for background, see
>> http://bugzilla.kernel.org/show_bug.cgi?id=13390).

> commit 0af49167b1e5ba154e90d2c454bf4624ee47df80
> Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
> Date:   Wed Oct 14 02:19:22 2009 +0100
>     Staging: rt2860sta: prevent a panic when disabling when associated

> while:

> ommit 5d315c4baa7be30e0fb8c924a64406492b2263b8
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Tue Sep 22 20:44:07 2009 +0200
>     Staging: rt28x0: updates from vendor's V2.1.0.0 drivers

> dropped cmm_data_2860.o from the build..

Ouch. ;-)

[snip]
>> Is this fix present (or, better, not needed) in the code which obsoletes
>> this file? (I can test if needed; just point me in the right direction
>> wrt patches or repositories.)

> It seems it is still needed so could you port it over to cmm_data_pci.c
> (just use staging or linux-next as a base)?

I've tested with the Ralink drivers from -next copied into my 2.6.32-rc6 tree
(which has one bad patch from -rc5 reverted, else the bug would be masked),
and all appears to be working well.

So, unless you think that extra belt and braces would be of use here, I'm not
going to bother porting it.

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
| + http://www.youmustbejoking.demon.co.uk/

Pssst... the root password is 'kumquat'.
