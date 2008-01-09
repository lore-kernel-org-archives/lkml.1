Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbYAIU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbYAIU0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 15:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYAIU0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 15:26:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54158 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbYAIU0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 15:26:31 -0500
Date: Wed, 9 Jan 2008 12:25:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109122559.38bc8c33@laptopd505.fenrus.org>
In-Reply-To: <20080109174800.GA15346@one.firstfloor.org>
References: <20080109035534.GA30321@basil.nowhere.org>
	<20080109090956.GA14274@elte.hu>
	<20080109141908.GB12855@one.firstfloor.org>
	<20080109152208.GA21280@elte.hu>
	<20080109155124.GB12923@one.firstfloor.org>
	<20080109163017.GG17739@elte.hu>
	<20080109174800.GA15346@one.firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 18:48:00 +0100
> And after all that's still by far the most common system call
> (not only for databases; i profiled this using systemtap in some
> loads some time ago and it usually came up with >50%) 
> and quite important for many workloads.
> 

btw be careful with this; the X server uses gettimeofday in it's equivalent of udelay()...
(and we all know how useful it is to make the delay loops faster ;-)
