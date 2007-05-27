Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXE0J5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXE0J5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 05:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXE0J47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 05:56:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXE0J46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 05:56:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Date: Sun, 27 May 2007 11:56:21 +0200
User-Agent: KMail/1.9.6
Cc: Indan Zupancic <indan@nul.nu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200705191443.27161.arvidjaar@mail.ru> <200705261802.08573.ak@suse.de> <20070527090542.GA18399@uranus.ravnborg.org>
In-Reply-To: <20070527090542.GA18399@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271156.22098.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> So section mismatch warnings are more about catching sloopy usage of __init than it is to
> catch potential kernel oopesen. But the latter is a nice side effect that is appreciated.

My point was that I cannot recall a single real oops bug found by the compile
time checking.

We had a few in the past, but since we poison init data after boot they all tended
to be found quickly anyways.

But the warnings just seem to require endless changes and bogus changes
(randomly moving code which was actually ok because it only called 
in the init case).

-Andi
