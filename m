Return-Path: <linux-kernel-owner+w=401wt.eu-S1752449AbXCZMhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbXCZMhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXCZMhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:37:25 -0400
Received: from gherkin.frus.com ([192.158.254.49]:35935 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbXCZMhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:37:24 -0400
Subject: Re: 2.6.21-rc4: known regressions with patches (v2)
In-Reply-To: <20070324112544.GB752@stusta.de> "from Adrian Bunk at Mar 24, 2007
 12:25:44 pm"
To: Adrian Bunk <bunk@stusta.de>
Date: Mon, 26 Mar 2007 07:37:22 -0500 (CDT)
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       tglx@linutronix.de, johnstul@us.ibm.com, bzolnier@gmail.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070326123722.4C17FDBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Subject    : boot hangs during IDE detection  (clocksource)
> References : http://lkml.org/lkml/2007/3/19/465
> Submitter  : Bob Tracy <rct@gherkin.frus.com>
> Caused-By  : John Stultz <johnstul@us.ibm.com>
>              commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
> Handled-By : John Stultz <johnstul@us.ibm.com>
> Patch      : http://lkml.org/lkml/2007/3/22/287
> Status     : workaround-patch available

The subject problem is fixed *without* the workaround patch in
2.6.21-rc5.  The acpi_pm clocksource patch for the case where the
PIIX4 bug is present should probably be included anyway.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
