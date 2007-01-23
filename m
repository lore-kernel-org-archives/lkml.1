Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbXAWAQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbXAWAQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932544AbXAWAQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:16:47 -0500
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:4861 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932541AbXAWAQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:16:46 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jan 2007 19:16:46 EST
Message-ID: <45B55286.5060909@nobaq.net>
Date: Tue, 23 Jan 2007 01:10:46 +0100
From: Niki Hammler <mailinglists@nobaq.net>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Why active list and inactive list?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Homepage: Niki Hammler, http://www.NOBAQ.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linux Developers/Enthusiasts,

For a course at my university I'm implementing parts of an operating
system where I get most ideas from the Linux Kernel (which I like very
much). One book I gain information from is [1].

Linux uses for its Page Replacing Algorithm (based on LRU) *two* chained
lists - one active list and one active list.
I implemented my PRA this way too.

No the big question is: WHY do I need *two* lists? Isn't it just
overhead/more work? Are there any reasons for that?

In my opinion, it would be better to have just one just; pop frames to
be swapped out from the end of the list and push new frames in front of
it. Then just evaluate the frames and shift them around in the list.

Is there any explanation why Linux uses two lists?

Thanks you very much in advance!

Best regards,
Niki



[1] Linux Kernelarchitektur. Konzepte, Strukturen und Algorithmen von
Kernel 2.6. Wolfang Mauerer, Hanser, ISBN 3-446-22566-8


