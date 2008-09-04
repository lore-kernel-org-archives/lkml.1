Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYIDXI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYIDXI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbYIDXIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:08:36 -0400
Received: from khc.piap.pl ([195.187.100.11]:57212 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYIDXIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:08:35 -0400
To: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
Cc: "Nye Liu" <nyet@mrv.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Nye Liu" <nyet@nyet.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS cpio images
References: <20080805195232.GA5183@curtisfong.org>
	<20080903202938.GA9065@curtisfong.org>
	<20080903152231.6b82d9bf.akpm@linux-foundation.org>
	<20080903223114.GA9456@mrv.com>
	<ac9c93b10809040011h19b70715ge2ba06372f1b0fe0@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 05 Sep 2008 01:08:32 +0200
In-Reply-To: <ac9c93b10809040011h19b70715ge2ba06372f1b0fe0@mail.gmail.com> (Frans Meulenbroeks's message of "Thu\, 4 Sep 2008 09\:11\:42 +0200")
Message-ID: <m3abenzez3.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Frans Meulenbroeks" <fransmeulenbroeks@gmail.com> writes:

> "Invaluable" != "nice to know".

Well, I guess it's as "invaluable" for embedded systems running on
initramfs as mtime on regular filesystems in case of normal systems.

Is mtime on ext3 "invaluable" or just "nice to know"?

> I admit that the net effect of this on boot time is marginal (but some
> might consider having mtime a marginal benefit), and 100 cents also
> make a dollar, so my suggestion would be to either reject this patch
> or make it optional (e.g. depending on some debug config flag).

It depends on how marginal is it. If it makes unpacking 1% slower I
can see no need for being optional. 10% - maybe it should?
-- 
Krzysztof Halasa
