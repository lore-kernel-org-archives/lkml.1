Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbYABXbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbYABXbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760114AbYABXaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:30:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:35589 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760713AbYABXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:30:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ZEW20SypAuI3ewcWwqqFOYvAhU6sqPWUR+J6fKn1KNDKpgJ8it1pqA6Hx2El9/32+Rk30HBDmg84jNxn8gqrHWxazKnWq0yK3sdQYap5tpLx8hXqFtn+Gnx61v8U20Gv3CcFadVtjyLYHxhXMp/hVGtEYK1TX60GjTsYsPTAtlk=
Message-ID: <477C1E73.3060808@gmail.com>
Date: Thu, 03 Jan 2008 00:29:55 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, trem <tremyfr@yahoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: tty + BKL [Was: 2.6.24-rc6-mm1]
References: <9DtBq-2jD-3@gated-at.bofh.it>	<200801022131.15482.nickpiggin@yahoo.com.au>	<1199271676.6821.112.camel@twins>	<200801022212.29303.nickpiggin@yahoo.com.au>	<1199273047.6821.119.camel@twins>	<20080102121909.GA6285@elte.hu>	<20080102132621.4da29e29@the-village.bc.nu>	<20080102161846.GA2755@elte.hu> <20080102224920.33993288@lxorguk.ukuu.org.uk>
In-Reply-To: <20080102224920.33993288@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2008 11:49 PM, Alan Cox wrote:
> Almost all the serial drivers clone the same open and release methods (or
> worse older versions of it) so that also needs doing. Lots to do, so
> little time.

Could you be more specific here please, maybe somebody could help.
