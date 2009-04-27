Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZD0PHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZD0PHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZD0PHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:07:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZD0PHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:07:17 -0400
Message-Id: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 17:01:14 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, monstr@monstr.eu, linux-api@vger.kernel.org,
       linux-arch@vger.kernel.org, liqin.chen@sunplusct.com,
       Sam Ravnborg <sam@ravnborg.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [RFC 00/17] asm-generic ABI files for microblaze
X-Provags-ID: V01U2FsdGVkX19naBeT2TdbBmifAncGJVvgYkoZd0MG1lWtOQj
 GWrxdM1jYvkTZaowGZOUCeAdDHCEsqSTJxqLPwaKnhp9NTCK2Y
 3bJMfNXtD93pbNTUnP8gw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my attempt to do a generic system call ABI for
all new architectures, including a port for microblaze,
which has recently been merged into 2.6.30. The next
architecture that is about to get merged will be score,
so it would be good if they can move to the same ABI.

Please review the files and (in case of microblaze
and score maintainers) test them on your architecture.

The one part I'm not yet completely happy with is signal
handling, I had to massage the microblaze code quite a
bit to get the old-style siginfo out of it, which may
not yet work.

Sam also mentioned that it might be good to consistently
use the __u32 and similar types everywhere in asm-generic
exported headers, which I might be doing as a next step
(including the existing files).

Special thanks to Remis Baima, who has done some significant
work cleaning up my patches.
Sorry for spamming everyone with the broken mail headers.
I hope this resend does fly better.

	Arnd <><

