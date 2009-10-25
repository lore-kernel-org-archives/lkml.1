Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZJYRMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZJYRMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZJYRMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:12:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:60607 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbZJYRMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:12:19 -0400
Date: Sun, 25 Oct 2009 10:11:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode
 messages
Message-ID: <20091025101118.522a7aa4@infradead.org>
In-Reply-To: <20091025163704.GE20391@elte.hu>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
	<20091023233756.941535000@alcatraz.americas.sgi.com>
	<b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>
	<Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
	<b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
	<20091025163704.GE20391@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009 17:37:04 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> Having the precise microcode version printed (or exposed somewhere in 
> /sys) is useful - sometimes when there's a weird crash in some
> prototype CPU one of the first questions from hw vendors is 'which
> precise microcode version was that?'.

something like
/sys/devices/system/cpu/cpu0/microcode/version ?

(yes that is there today ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
