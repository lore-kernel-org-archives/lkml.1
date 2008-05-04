Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYEDSlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYEDSlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 14:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbYEDSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 14:41:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYEDSlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 14:41:00 -0400
Date: Sun, 4 May 2008 20:40:58 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
In-Reply-To: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0805042037100.11757@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-05-03 21:38, Linus Torvalds wrote:
>
>So go out and test it. The diffstat and shortlogs are too big to post here 
>(7500+ commits and the compressed full patch is 8.5MB in size), but one 
>interesting tidbit I found was that during this *one* merge window, we had 
>almost 800 different authors.
>Now, some of them will have gotten counted 
>multiple times due to different versions of the same name, and I didn't 
>filter that, but from a quick look, that is been pretty rare.

Just 800. We have already been past that:

git shortlog v2.6.24..v2.6.25-rc1 | grep -Pv '^( |$)' | wc -l
918
