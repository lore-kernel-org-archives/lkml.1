Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYBYL1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYBYL1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYBYL1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:27:36 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:54571 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYBYL1f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:27:35 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] Add rdc321x defconfig file
Date: Mon, 25 Feb 2008 12:27:34 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225105110.GA5648@elte.hu> <20080225111733.GB32450@cs181133002.pp.htv.fi>
In-Reply-To: <20080225111733.GB32450@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802251227.37435.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 25 février 2008, Adrian Bunk a écrit :
> Booting it might fine, but CLOCK_TICK_RATE will be wrong...

PIT_TICK_RATE is overriden specificaly for R321x in include/asm-x86/timex.h, 
just like for AMD Elan.
