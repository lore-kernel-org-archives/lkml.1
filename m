Return-Path: <linux-kernel-owner+w=401wt.eu-S1751379AbXE2XuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbXE2XuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXE2Xt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:49:56 -0400
Received: from mailout05.sul.t-online.com ([194.25.134.82]:54267 "EHLO
	mailout05.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbXE2Xtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:49:55 -0400
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 19:49:55 EDT
Message-ID: <465CB7CF.2060509@t-online.de>
Date: Wed, 30 May 2007 01:31:27 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070519)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bryan Wu <bryan.wu@analog.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] Blackfin update for 2.6.22-rc3
References: <11803414753217-git-send-email-bryan.wu@analog.com> <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705291356290.26602@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: SaUzGyZcYekkmDymsEo09a9ScWy1IZ+yFKMLAkbe2v7MscfwvbB9Yn
X-TOI-MSGID: 1efca3e0-ecde-4397-b64c-4c1d21b66417
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 28 May 2007, Bryan Wu wrote:
>>  - Blackfin arch update including BF54x initial supporting
>>  - Blackfin driver update: serial/spi/rtc
>>  - Provide new Blackfin watchdog driver
>>  - binfmt_flat.c for Blackfin arch modification
> 
> I realize that this all just touches blackfin-specific stuff, but after 
> -rc3 I really prefer not to bother with these things..
> 
> Also, for stuff that is really just an architecture that I can't even 
> test, and where there is a clear maintainership thing, I'd actually prefer 
> to just do a git merge, if possible. It's not like I will likely start 
> looking at some blackfin-specific patches. Judging from the diffs, you do 
> actually use git, do you have a place where you could export these kinds 
> of patch-series as a git tree instead?

The binfmt_flat patch also touches other nommu architectures.  Do you
want these kinds of patches (which aren't just Blackfin-specific)
separately as they come up?


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
