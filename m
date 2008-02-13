Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYBMNfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYBMNfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 08:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753451AbYBMNez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 08:34:55 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61983 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbYBMNey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 08:34:54 -0500
Date: Wed, 13 Feb 2008 14:34:45 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tests of undefined CONFIG variables.
Message-ID: <20080213143445.7a9e82c6@dhcp-252-066.norway.atmel.com>
In-Reply-To: <alpine.LFD.1.00.0802130552370.19968@localhost.localdomain>
References: <alpine.LFD.1.00.0802130552370.19968@localhost.localdomain>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 05:54:12 -0500 (EST)
"Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

>   i've also updated the list of what i call "badref" CONFIG variables
> -- that is, tests of CONFIG_ variables that appear to be undefined
> anywhere in a Kconfig file (which typically represents a meaningless
> test, naturally).

I've fixed BOARD_ATSTK1002_SW2_CUSTOM, thanks. It was a real bug.

As for AP7000_8_BIT_SMC, it is sort-of used. It is part of a choice
menu where the other two choices are used like this:

#if defined(CONFIG_AP700X_32_BIT_SMC)
...
#elif defined(CONFIG_AP700X_16_BIT_SMC)
...
#else
...
#endif

and the #else block covers the only remaining choice, AP700X_8_BIT_SMC.

I can fix it by turning the #else above into an #elif I guess.

Haavard
