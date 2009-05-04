Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZEDVUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZEDVUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZEDVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:19:53 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54833 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbZEDVTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:19:52 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: "N" symbols and System.map
References: <49FB7692.2000508@linux.intel.com> <m2preso1wl.fsf@igel.home>
	<20090501232149.GA28888@uranus.ravnborg.org>
	<49FB8D27.3000305@linux.intel.com>
	<20090504193336.GA10453@uranus.ravnborg.org>
X-Yow: Now I'm concentrating on a specific tank battle toward
 the end of World War II!
Date: Mon, 04 May 2009 23:19:45 +0200
In-Reply-To: <20090504193336.GA10453@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Mon, 4 May 2009 21:33:36 +0200")
Message-ID: <m2skjkzhu6.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> writes:

> Andreas - can you explain what is happning here?

My best guess would be that it has to do with the fact that the _end
symbol is attached to the .end section which is located before the debug
sections, but the .end section is empty, so the symbol has the same
address as the following debug section.  The ppc linker script does not
attach the _end symbol to any section, so it becomes an absolute symbol.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
