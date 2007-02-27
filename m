Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbXB0Gym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbXB0Gym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 01:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXB0Gyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 01:54:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:37212 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXB0Gyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 01:54:41 -0500
Subject: Re: [patch 0/6] fault vs truncate/invalidate race fix
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970702262226v6fc70e06jd759c66c383630e1@mail.gmail.com>
References: <20070221023656.6306.246.sendpatchset@linux.site>
	 <21d7e9970702262036h3575229ex3bf3cd4474a57068@mail.gmail.com>
	 <20070226213204.14f8b584.akpm@linux-foundation.org>
	 <21d7e9970702262226v6fc70e06jd759c66c383630e1@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 07:54:22 +0100
Message-Id: <1172559262.11949.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> the new fault hander made the memory manager code a lot cleaner and
> very less hacky in a lot of cases. so I'd rather merge the clean code
> than have to fight with the current code...

Note that you can probably get away with NOPFN_REFAULT etc... like I did
for the SPEs in the meantime.

Ben.


