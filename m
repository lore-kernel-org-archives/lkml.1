Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbYCCKVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbYCCKVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYCCKU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:20:59 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:23724 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbYCCKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:20:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MKY85xGXAUrMcTTXPoUdMRang2PLhfGSSq2IS7h7lm+Uze3Yuta6x4EhAnwX9QYiRSNf6R6hqPv3tsa2M/9/zhbouef9oUc2WKCgDnMjATNpzK5vJ9U2k/Qn8ahF9UErdthN/aMCxGg4ELG+LZXAYu/EBNHpkv5bArbcDC+PjnE=
Message-ID: <cfd18e0f0803030220w6bde288bo5ef085db8b3412e3@mail.gmail.com>
Date: Mon, 3 Mar 2008 11:20:55 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: SCHED_IDLE documentation
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Christoph Hellwig" <hch@lst.de>,
       cbe-oss-dev@ozlabs.org, "Jeremy Kerr" <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080303101751.GA21190@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203376368.275756.252634247263.1.gpush@pokey>
	 <200803030612.28039.arnd@arndb.de> <20080303051719.GA26102@lst.de>
	 <200803030721.52869.arnd@arndb.de> <20080303073311.GB5934@elte.hu>
	 <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com>
	 <20080303092422.GA18281@elte.hu>
	 <cfd18e0f0803030207j73da3172mf9470859bb918546@mail.gmail.com>
	 <20080303101751.GA21190@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 11:17 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Michael Kerrisk <mtk.manpages@googlemail.com> wrote:
>
>
> > >  commit 0e6aca43e08a62a48d6770e9a159dbec167bf4c6
>  > >  Author: Ingo Molnar <mingo@elte.hu>
>  > >  Date:   Mon Jul 9 18:51:57 2007 +0200
>  >
>  > Yep -- I found it later -- thanks.
>  >
>  > Ingo, could you please CC me when kernel-userland API changes go into
>  > mainline?  Otherwise, they potentially end up undocumented, and
>  > un(der)used.
>
>  sure.
>
>  We could also add an in-commit-message marker for such changes, that you
>  could periodically scan. Something like:
>
>    User-ABI-extended-by: Ingo Molnar <mingo@elte.hu>
>
>  and:
>
>    User-ABI-modified-by: Ingo Molnar <mingo@elte.hu>
>
>  that way you also know whom to contact about followup questions.
>
>  Declaring such changes would have other benefits as well: the review
>  process becomes more streamlined. Also, any ABI side-effect would be
>  known to be intentional versus unintentional, based on the commit
>  headers alone. Undeclared ABI side-effects would be frowned upon and
>  would be strong grounds for immediate reversal as well.

Sounds like an excellent idea, if we could make it fly.  How can we make it fly?

Cheers,

Michael


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
