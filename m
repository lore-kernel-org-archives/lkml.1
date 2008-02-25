Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYBYLqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYBYLqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 06:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYBYLqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 06:46:45 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54455 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbYBYLqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 06:46:45 -0500
Date: Mon, 25 Feb 2008 13:45:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Add rdc321x defconfig file
Message-ID: <20080225114547.GD32450@cs181133002.pp.htv.fi>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225105110.GA5648@elte.hu> <20080225111733.GB32450@cs181133002.pp.htv.fi> <200802251227.37435.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802251227.37435.florian.fainelli@telecomint.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 12:27:34PM +0100, Florian Fainelli wrote:
> Le lundi 25 février 2008, Adrian Bunk a écrit :
> > Booting it might fine, but CLOCK_TICK_RATE will be wrong...
> 
> PIT_TICK_RATE is overriden specificaly for R321x in include/asm-x86/timex.h, 
> just like for AMD Elan.

Not when you try CONFIG_X86_GENERICARCH=y as Ingo suggested.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

