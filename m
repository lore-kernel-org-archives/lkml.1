Return-Path: <linux-kernel-owner+w=401wt.eu-S1751863AbXBRS55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbXBRS55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 13:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXBRS55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 13:57:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:41840 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751863AbXBRS5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 13:57:53 -0500
X-Provags-ID: V01U2FsdGVkX1/gVUwR5T/gEStyxWwpLa2zZB5tAfmekf3LC6mQKA
	MNvQ==
From: "Tobias Hain" <tobias.hain@gmx.de>
To: "'Zwane Mwaikambo'" <zwane@infradead.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
       "'Andi Kleen'" <ak@suse.de>, "'H. Peter Anvin'" <hpa@zytor.com>
Subject: AW: [PATCH] Don't probe for DDC on VBE1.2
Date: Sun, 18 Feb 2007 19:57:48 +0100
Message-ID: <000001c7538e$b1000b20$797ba8c0@broy.ad.informatik.tumuenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcdSbqYaJ+b+NUzdRmqlqXFLu+KFkgBH6erQ
In-Reply-To: <Pine.LNX.4.64.0702170024270.11321@montezuma.fsmlabs.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok it looks like i was corrupting the modelist. The following should take 
> care of your VAIO, but i haven't tested the failure case as Tobias is away

> this weekend.

Yes, this last patch also works on VBE 1.2: It skips the EDID calls, which
would crash my system here, and consequently boots the kernel fine.

Thanks,
tobias

