Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbXKUH41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbXKUH41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbXKUH4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:56:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbXKUH4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:56:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] x86 vDSO: vdso32 build
In-Reply-To: Sam Ravnborg's message of  Wednesday, 21 November 2007 08:32:46 +0100 <20071121073246.GA449@uranus.ravnborg.org>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	<20071119220532.029FC26F8BE@magilla.localdomain>
	<20071121060201.GA32304@uranus.ravnborg.org>
	<20071121071015.B8E3A26F8BE@magilla.localdomain>
	<20071121073246.GA449@uranus.ravnborg.org>
Emacs: because one operating system isn't enough.
Message-Id: <20071121075542.308ED26F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 23:55:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I assume that if an error happened in a pipe set -e; would catch it.
> But I did not check that - I normally just adds set -e; without much thought.

No, you need set -o pipefail for that (which is a bashism).


Thanks,
Roland
