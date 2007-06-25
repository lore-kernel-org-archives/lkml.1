Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbXFYWav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbXFYWav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXFYWao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:30:44 -0400
Received: from ns.mimer.no ([213.184.200.1]:46602 "EHLO odin.mimer.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXFYWan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:30:43 -0400
From: Harald Arnesen <harald@skogtun.org>
To: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, david@lang.hm
Subject: Re: Linux Kernel include files
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
	<Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
	<467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
	<1182483527.10524.31.camel@shinybook.infradead.org>
	<467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
	<1182785277.12109.121.camel@pmac.infradead.org>
	<87wsxrdi6e.fsf@basilikum.skogtun.org>
	<468024ec.9RebHj/O0BpNRyoY%Joerg.Schilling@fokus.fraunhofer.de>
	<87ir9byak9.fsf@basilikum.skogtun.org>
	<87ejjzyac0.fsf@basilikum.skogtun.org>
	<4680384e.iAYvC5ix5Dbya44W%Joerg.Schilling@fokus.fraunhofer.de>
Date: Tue, 26 Jun 2007 00:30:32 +0200
In-Reply-To: <4680384e.iAYvC5ix5Dbya44W%Joerg.Schilling@fokus.fraunhofer.de>
	(Joerg Schilling's message of "Mon, 25 Jun 2007 23:49:02 +0200")
Message-ID: <87hcovy8dz.fsf@basilikum.skogtun.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling) writes:

>> FYI, cdrtools also compile and link fine with Sun's C compiler.
>
> Mmmmm, if you call "cdrecord -scanbus", what do you get?

I may have misunderstood your make system. I cd-ed into the cdrtools
directory, ran ./Gmake.linux clean (I had already compiled with GCC),
and then ./Gmake.linux CCOM=suncc. I didn't see any errors at the end of
the make output.

However, what confused me was that the cdrecord binary wasn't removed.
And scrolling back, I see several compile errors from Sun's C compiler.

Shouldn't "make clean" remove the executable files?
-- 
Hilsen Harald.

