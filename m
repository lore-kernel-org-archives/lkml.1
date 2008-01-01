Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbYAAXLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbYAAXLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 18:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYAAXLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 18:11:48 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:53594 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbYAAXLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 18:11:47 -0500
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2008 18:11:47 EST
X-Auth-Info: s6NIofJQ+pnEDj6QQoF9ZAb9dHQ+Rn6GzrsEXHhL/AM=
X-Auth-Info: s6NIofJQ+pnEDj6QQoF9ZAb9dHQ+Rn6GzrsEXHhL/AM=
X-Auth-Info: s6NIofJQ+pnEDj6QQoF9ZAb9dHQ+Rn6GzrsEXHhL/AM=
X-Auth-Info: s6NIofJQ+pnEDj6QQoF9ZAb9dHQ+Rn6GzrsEXHhL/AM=
X-Auth-Info: s6NIofJQ+pnEDj6QQoF9ZAb9dHQ+Rn6GzrsEXHhL/AM=
To: Adrian Bunk <bunk@kernel.org>
cc: Thomas Gleixner <tglx@cruncher.tec.linutronix.de>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [2.6 patch] remove broken MTD drivers
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: Your message of "Tue, 01 Jan 2008 15:48:39 +0200."
             <20080101134839.GN2360@does.not.exist>
Date: Tue, 01 Jan 2008 23:58:04 +0100
Message-Id: <20080101225804.F13AA24889@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080101134839.GN2360@does.not.exist> you wrote:
> This patch removes two MTD drivers that have been marked as
> BROKEN 19 months ago due to requiring nonexisting header files.
...
>  drivers/mtd/nand/Kconfig          |   12 
>  drivers/mtd/nand/Makefile         |    2 
>  drivers/mtd/nand/ppchameleonevb.c |  439 ------------------------------

It would have been nice if you had put the autors of the files on Cc:

Regarding the PPChameleon NAND support: I discussed this issue with
tglx on 23 June 2006. Thomas promised to fix the driver if I send him
the missing file and eventually needed patches.

I did so on Fri, 23 Jun 2006 23:23:42 +0200.

Thomas, can you please have a look at this?

If you don't have time / resources please let me know so we can submit
the stuff here on the list...

Thanks.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"More software projects have gone awry for lack of calendar time than
for all other causes combined."
                         - Fred Brooks, Jr., _The Mythical Man Month_
