Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXERVPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXERVPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXERVPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:15:00 -0400
Received: from khc.piap.pl ([195.187.100.11]:41117 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERVO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:14:59 -0400
To: "Nitin Gupta" <nitingupta910@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>
Subject: Re: [RFC] LZO1X de/compression support
References: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 18 May 2007 23:14:57 +0200
In-Reply-To: <4cefeab80705180258g516a6f92w15a49e666dd62b66@mail.gmail.com> (Nitin Gupta's message of "Fri, 18 May 2007 15:28:31 +0530")
Message-ID: <m3646pg7fy.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Nitin Gupta" <nitingupta910@gmail.com> writes:

> Facts for LZO (at least for original code. Should hold true for this
> port also - hence the RFC!):
> - The compressor can never overrun buffer.
> - The "non-safe" version of decompressor can never overrun buffer if
> compressed data is unmodified. I am not sure about this if compressed
> data is malicious (to be confirmed from the author).
> - The "safe" version can never crash (buffer overrun etc.) - confirmed
> from the author.

I'm certainly missing something but what are the advantages of this
code (over current gzip etc.), and what will be using it?
-- 
Krzysztof Halasa
