Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZELJSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZELJSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZELJR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:17:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40652 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752156AbZELJRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:17:55 -0400
Date: Tue, 12 May 2009 10:17:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: Re: [PATCH v2] x86: fix ktermios-termio conversion
Message-ID: <20090512101748.7ef97b5e@lxorguk.ukuu.org.uk>
In-Reply-To: <200905121104.31275.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>
	<200905112319.17999.arnd@arndb.de>
	<20090512075513.GA14122@elte.hu>
	<200905121104.31275.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I now tried this version, which theoretically should be
> fairly compact on most architectures:

We don't really need to inline any of this btw - its an back compat
obscure path so its not performance relevant at all.

We probably should fix c_line but the rest is hardly worth the bother.
