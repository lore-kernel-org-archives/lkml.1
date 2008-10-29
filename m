Return-Path: <linux-kernel-owner+w=401wt.eu-S1752836AbYJ2GR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbYJ2GR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 02:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYJ2GRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 02:17:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32216 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbYJ2GRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 02:17:46 -0400
Subject: Re: How do I printk <type> correctly?
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
       ericvh@gmail.com, mfasheh@suse.com
In-Reply-To: <20081028161136.c652b9fd.randy.dunlap@oracle.com>
References: <20081023114133.GA30187@x200.localdomain>
	 <20081028161136.c652b9fd.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Oct 2008 08:15:57 +0200
Message-Id: <1225260957.4350.7.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Oct 2008 06:17:27.0115 (UTC) FILETIME=[03F2C1B0:01C9398E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 16:11 -0700, Randy Dunlap wrote:
> fs/ubifs/journal.c:693: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/journal.c:1131: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/dir.c:163: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/tnc.c:2680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/tnc.c:2700: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/replay.c:1066: warning: format '%lu' expects type 'long unsigned int', but argument 7 has type 'ino_t'
> fs/ubifs/orphan.c:108: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:135: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:142: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:154: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:159: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:451: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:539: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:612: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:843: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/orphan.c:856: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1438: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1443: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1475: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/recovery.c:1495: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:105: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:110: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:114: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:118: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'ino_t'
> fs/ubifs/debug.c:1591: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1671: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1674: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1680: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1699: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1788: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1821: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1833: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:1924: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1932: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1938: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1945: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1953: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1960: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1967: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1973: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1988: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'ino_t'
> fs/ubifs/debug.c:1991: warning: format '%lu' expects type 'long unsigned int', but argument 5 has type 'ino_t'
> fs/ubifs/debug.c:2009: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'ino_t'

I'll look at these and fix, thank you!

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

