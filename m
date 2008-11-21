Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYKUM6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYKUM6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYKUM6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:58:33 -0500
Received: from ns1.suse.de ([195.135.220.2]:41009 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYKUM6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:58:33 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Daney <ddaney@caviumnetworks.com>,
       linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
References: <49260E4C.8080500@caviumnetworks.com>
	<20081121100035.3f5a640b@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811211126420.26004@anakin>
	<alpine.LFD.1.10.0811211059290.20023@ftp.linux-mips.org>
X-Yow: RELATIVES!!
Date: Fri, 21 Nov 2008 13:58:30 +0100
In-Reply-To: <alpine.LFD.1.10.0811211059290.20023@ftp.linux-mips.org> (Maciej
	W. Rozycki's message of "Fri, 21 Nov 2008 11:14:30 +0000 (GMT)")
Message-ID: <jezljtxmkp.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Maciej W. Rozycki" <macro@linux-mips.org> writes:

> Otherwise it looks like the attribute is useless -- it looks like it can 
> only be used for functions where GCC can determine the function does not 
> return anyway.  Which means it is redundant.

The purpose of the attribute is to tell the _callers_ of this function
that it does not return.  It does not change how the attributed function
itself is compiled.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
