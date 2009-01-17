Return-Path: <linux-kernel-owner+w=401wt.eu-S932630AbZAQWXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbZAQWXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760631AbZAQWXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:23:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:33145 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZAQWXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:23:20 -0500
Subject: Re: [GIT PULL -tip] fix 33 make headers_check warnings
From: David Woodhouse <dwmw2@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, urs.thuermann@volkswagen.de,
       oliver.hartkopp@volkswagen.de, linux-media@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       bfields@fieldses.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-raid@vger.kernel.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, netdev@vger.kernel.org,
       greg@kroah.com, linux-usb@vger.kernel.org,
       linux-mtd@lists.infradead.org, tiwai@suse.de, mchehab@infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090117221932.GA4956@uranus.ravnborg.org>
References: <1232223441.3966.22.camel@localhost.localdomain>
	 <1232228261.27094.0.camel@macbook.infradead.org>
	 <20090117221932.GA4956@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 09:23:00 +1100
Message-Id: <1232230980.27094.15.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 23:19 +0100, Sam Ravnborg wrote:
> Nope - include/linux/dvb/audio.h failed to include linux/types.h
> despite the fact that is uses __u32 etc.

Er, good point. I saw the <stdint.h> and assumed it was using only
proper C types... but then it wouldn't have triggered the warning, would
it? Too much time in tin cans and not enough sleep...

-- 
dwmw2

