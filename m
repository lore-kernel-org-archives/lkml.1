Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbZHQLyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbZHQLyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757879AbZHQLyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:54:33 -0400
Received: from www.lumino.de ([85.159.12.10]:33249 "HELO imap.lumino.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757878AbZHQLyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:54:32 -0400
Message-ID: <4A8944B3.8010201@lumino.de>
Date: Mon, 17 Aug 2009 13:53:23 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: nios2-dev@sopc.et.ntust.edu.tw
CC: Arnd Bergmann <arnd@arndb.de>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [Nios2-dev] implementing Futex
References: <4A842B32.5030401@lumino.de> <200908131839.41803.arnd@arndb.de> <4A8919CB.4000709@lumino.de>
In-Reply-To: <4A8919CB.4000709@lumino.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some more thoughts it's obvious that we should do the
return-PC-tweaking according to the "custom ie" flag in the ISR entry
code rather than in the Kernel exit code, as the exit will go to another
process than the one that was interrupted ans did set the flag. I don't
know if that is more difficult than using the exit code (as blackfin does).

-Michael
