Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZEDVkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZEDVkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZEDVjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:39:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:23162 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbZEDVjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:39:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,293,1239001200"; 
   d="scan'208";a="687433246"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andreas Schwab <schwab@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Date: Mon, 4 May 2009 14:39:50 -0700
Subject: RE: "N" symbols and System.map
Thread-Topic: "N" symbols and System.map
Thread-Index: AcnM/hK610zpnm9hSk+5rd4BmeOFPwAAn+Jw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EFE2CCB@orsmsx505.amr.corp.intel.com>
References: <49FB7692.2000508@linux.intel.com> <m2preso1wl.fsf@igel.home>
	<20090501232149.GA28888@uranus.ravnborg.org>
	<49FB8D27.3000305@linux.intel.com>
	<20090504193336.GA10453@uranus.ravnborg.org> <m2skjkzhu6.fsf@igel.home>
In-Reply-To: <m2skjkzhu6.fsf@igel.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My best guess would be that it has to do with the fact that the _end
> symbol is attached to the .end section which is located before the debug
> sections, but the .end section is empty, so the symbol has the same
> address as the following debug section.

Perhaps a good guess.  Putting something (". = . + PAGE_SIZE;") into
the .end section makes _end change type from "N" tp "B".

-Tony
