Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZIHMDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZIHMDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZIHMDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:03:15 -0400
Received: from THUNK.ORG ([69.25.196.29]:38291 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbZIHMDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:03:15 -0400
Date: Tue, 8 Sep 2009 08:03:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090908120311.GK22901@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nikos Chantziaras <realnc@arcor.de>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org
References: <20090906205952.GA6516@elte.hu> <h81v7t$p6e$1@ger.gmane.org> <20090907074039.1b6bc1ac@infradead.org> <4AA6056A.4020106@arcor.de> <20090908013800.296a5fb5@infradead.org> <4AA62E4E.4040700@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA62E4E.4040700@arcor.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 01:13:34PM +0300, Nikos Chantziaras wrote:
>> despite the untranslated content, it is clear that you have scheduler
>> delays (either due to scheduler bugs or cpu contention) of upto 68
>> msecs... Second in line is your binary AMD graphics driver that is
>> chewing up 14% of your total latency...
>
> I've now used a correctly installed and up-to-date version of latencytop  
> and repeated the test.  Also, I got rid of AMD's binary blob and used  
> kernel DRM drivers for my graphics card to throw fglrx out of the  
> equation (which btw didn't help; the exact same problems occur).
>
> Here the result:
>
>     http://foss.math.aegean.gr/~realnc/pics/latop2.png

This was with an unmodified 2.6.31-rcX kernel?  Does Latencytop do
anything useful on a BFS-patched kernel?

							- Ted
