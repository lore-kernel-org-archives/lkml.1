Return-Path: <linux-kernel-owner+w=401wt.eu-S1763516AbXEWQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763516AbXEWQA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbXEWQAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:00:16 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:60073 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbXEWQAO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:00:14 -0400
Date: Thu, 24 May 2007 01:00:33 +0900 (JST)
Message-Id: <20070524.010033.55485829.anemo@mba.ocn.ne.jp>
To: mika.penttila@kolumbus.fi
Cc: torvalds@linux-foundation.org, ben.collins@ubuntu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       sam@ravnborg.org, dwmw2@infradead.org, adobriyan@gmail.com
Subject: Re: [RFC] Crash on modpost, addend_386_rel()
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <46545C65.3030806@kolumbus.fi>
References: <465302A9.8080701@kolumbus.fi>
	<20070523.235103.128617660.anemo@mba.ocn.ne.jp>
	<46545C65.3030806@kolumbus.fi>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 18:23:17 +0300, Mika_Penttilä <mika.penttila@kolumbus.fi> wrote:
> So with mips64 you are lucky because the relocation symbol is .init.text 
> and hence addend matches  (has to match) symbol's offset. I can't find 
> any spec where it is stated that addend == address, maybe it's in mips64 
> abi or something. It is quite normal to have addend of 0.

The RELA part was added for other archs first (actually at that time
it was broken on MIPS64 due to it's unusual layout).  So it would be
irrelevant to MIPS64 ABI.  Unfortunately I do not know details, just
tried to hack mips/mips64 stuff.

---
Atsushi Nemoto
