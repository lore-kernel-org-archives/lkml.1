Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbYD2KWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbYD2KWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYD2KWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:22:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33346 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753468AbYD2KWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:22:05 -0400
Date: Tue, 29 Apr 2008 11:10:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429111014.5a065b88@core>
In-Reply-To: <20080429100934.GB1473@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
	<20080428230524.GK8474@1wt.eu>
	<48167A07.4000305@kernel.org>
	<20080429050605.GA27875@1wt.eu>
	<20080429072911.GA28059@cs181133002.pp.htv.fi>
	<20080429081423.GD30507@1wt.eu>
	<4816E4FD.5060605@aitel.hist.no>
	<20080429100934.GB1473@1wt.eu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, booting 2.6.25 with "init=/bin/bash" results in backspace
> eating the prompt after pressing accentuated letters. Even the

Did you put the bash shell and the console into unicode mode ?

> Funny that you mention Windows. Windows has been using 16-bit unicode
> for a long time without problems. It's a clean encoding. Like it or not.

I would describe the UCS-2 situation as a disaster area - embedded nuls
causing breakage, inability to represent the full unicode space and
awkward programming interfaces.

> You know why we got this encoding ? Simply because it was designed by
> english speakers who did not want to be impacted at all by the transition.

Actually it was primarily designed to make moving encoding painless so
that ascii still worked and C properties like \0 plus traditional
Unixisms like "/" just worked.

> BTW, do you have an UTF-8 patch for the vt320 and vt510 I use as an
> always-on console on my servers ? Clearly, the system does not have to

screen supports the needed transliteration for you.

Alan
--
"Having worked in a university for more than twenty years after leaving
 industry, I had become unused to seeing management skill routinely
 exercised, universities being administered rather than managed"
                -- Peter Checkland

