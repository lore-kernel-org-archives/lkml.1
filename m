Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXLEM3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXLEM3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXLEM3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:29:14 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:39905 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXLEM3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:29:13 -0500
Date: Wed, 5 Dec 2007 13:29:12 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071205122912.GC24685@torres.zugschlus.de>
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204161811.GB15974@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 05:18:11PM +0100, Adrian Bunk wrote:
> On Tue, Dec 04, 2007 at 12:41:25PM +0100, Marc Haber wrote:
> > While debugging Exim4's GnuTLS interface, I recently found out that
> > reading from /dev/urandom depletes entropy as much as reading from
> > /dev/random would. This has somehow surprised me since I have always
> > believed that /dev/urandom has lower quality entropy than /dev/random,
> > but lots of it.
> 
> man 4 random

Thanks for this pointer, I was not aware of the documentation. After
reading this thread and the docs, I am now convinced that GnuTLS
should seed a PRNG from /dev/(u)random instead of using the entropy
directly. I will go filing a bug against GnuTLS.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
