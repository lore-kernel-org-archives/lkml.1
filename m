Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZBJAKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZBJAKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 19:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZBJAJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 19:09:51 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:44133 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZBJAJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 19:09:50 -0500
Date: Mon, 9 Feb 2009 17:09:48 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Jean Pihet <jpihet@mvista.com>
cc: Andrew Morton <akpm@linux-foundation.org>, tony@atomide.com,
       ext-adrian.hunter@nokia.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org, jarkko.lavinen@nokia.com,
       drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP: MMC: recover from transfer failures - Resend
In-Reply-To: <200902061422.32689.jpihet@mvista.com>
Message-ID: <alpine.DEB.2.00.0902091707330.12013@utopia.booyaka.com>
References: <20081207213617.10456.43951.stgit@localhost> <20090205121045.4022c319.akpm@linux-foundation.org> <alpine.DEB.2.00.0902051323090.8131@utopia.booyaka.com> <200902061422.32689.jpihet@mvista.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Jean Pihet wrote:

> Do you want a finite loop with udelay in it? I located 4 places were this 
> could be used. If so I can generate a new patch for that.

Just as an aside, from the standpoint of minimizing CPU usage, there seems 
little point in using udelay() here, since it is implemented as a CPU 
busy-wait.


- Paul
