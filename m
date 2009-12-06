Return-Path: <linux-kernel-owner+w=401wt.eu-S933737AbZLFSin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbZLFSin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbZLFSik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:38:40 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:42271 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311AbZLFSik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:38:40 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT pull] BKL removal in drivers for 2.6.33
Date: Sun, 6 Dec 2009 19:38:57 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <alpine.LFD.2.00.0912061856100.3089@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912061856100.3089@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912061938.57096.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 6. Dezember 2009 18:57:26 schrieb Thomas Gleixner:
> Thomas Gleixner (12):
>       drivers: Remove BKL from misc_open

Have you verified no misc driver uses BKL to guard against other calls?

	Regards
		Oliver
