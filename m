Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbZELKGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbZELKGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759991AbZELKFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:05:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48082 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760066AbZELKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:05:45 -0400
Date: Tue, 12 May 2009 11:05:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Message-ID: <20090512110527.5352cd0e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090512092601.GB29796@elte.hu>
References: <20090511222702.352192505@arndb.de>
	<200905112319.17999.arnd@arndb.de>
	<20090512075513.GA14122@elte.hu>
	<200905121104.31275.arnd@arndb.de>
	<20090512091010.GD18004@elte.hu>
	<20090512102105.291afe53@lxorguk.ukuu.org.uk>
	<20090512092601.GB29796@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My argument was very simple: the patch causes +150 bytes of bloat. 
> The try/ex/catch method can help reduce register pressure and can 
> reducethe size of code quite visibly.

My argument is even simpler - its not worth the effort in the first place.

I'm sure you could use the same time to shave 150 bytes and a few clocks
of a path that actually gets executed.

Arnd - can you send me a diff that keeps the existing horrible macro
version, the existing __put_user usage and just fixes c_line ? It's
worked for 15 years, its not worth the time being fancy with it.

Alan
