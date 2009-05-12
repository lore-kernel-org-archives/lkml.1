Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZELJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZELJVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZELJVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:21:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40675 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750709AbZELJVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:21:23 -0400
Date: Tue, 12 May 2009 10:21:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Message-ID: <20090512102105.291afe53@lxorguk.ukuu.org.uk>
In-Reply-To: <20090512091010.GD18004@elte.hu>
References: <20090511222702.352192505@arndb.de>
	<200905112319.17999.arnd@arndb.de>
	<20090512075513.GA14122@elte.hu>
	<200905121104.31275.arnd@arndb.de>
	<20090512091010.GD18004@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, on x86 you could use get_user_try / get_user_ex() / 
> get_user_catch() approach to linearize the dependencies and reduce 
> register pressure.

It used *once*, in a path that is never executed except by some ancient
binaries. It isn't worth the effort.
