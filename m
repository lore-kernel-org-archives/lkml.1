Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbZADM2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbZADM2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZADM2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:28:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33709 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZADM2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:28:33 -0500
Date: Sun, 4 Jan 2009 13:28:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Baodong Chen <chenbdchenbd@gmail.com>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] Documentation/x86/boot.txt:payload length was changed
	to payload_length
Message-ID: <20090104122822.GA6485@elte.hu>
References: <d204e3110901022037i4c0e077ck6cefcf35f6048318@mail.gmail.com> <alpine.LNX.1.10.0901040024560.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901040024560.5377@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> 
> [ added Ingo to CC ]
> 
> Ingo, I guess you are going to take the patch through x86 tree, so I 
> wouldn't bother merging it through trivial tree, right?

yeah - applied it to tip/x86/cleanups, see the commit below. Thanks,

	Ingo

--------------->
>From 28178cc4f92d7c62889cf5d0d9e709cde04c76ca Mon Sep 17 00:00:00 2001
From: Baodong Chen <chenbdchenbd@gmail.com>
Date: Sat, 3 Jan 2009 12:37:06 +0800
Subject: [PATCH] Documentation/x86/boot.txt: payload length was changed to payload_length

Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/x86/boot.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index fcdc62b..7b4596a 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -44,7 +44,7 @@ Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised boot protocol.
 		and KEEP_SEGMENTS flag in load_flags.
 
 Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
-		payload. Introduced payload_offset and payload length
+		payload. Introduced payload_offset and payload_length
 		fields to aid in locating the payload.
 
 Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
