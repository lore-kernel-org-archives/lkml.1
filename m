Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbXHEEln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbXHEEln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 00:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXHEElf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 00:41:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbXHEEle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 00:41:34 -0400
Date: Sat, 4 Aug 2007 21:41:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Collins <paul@briny.ondioline.org>, Ingo Molnar <mingo@elte.hu>
cc: paulus@samba.org, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: "Badness at kernel/irq/resend.c:70" on boot - via-pmu?
In-Reply-To: <87sl6ypsx2.fsf@briny.wgtn.ondioline.org>
Message-ID: <alpine.LFD.0.999.0708042139300.5037@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
 <87sl6ypsx2.fsf@briny.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Aug 2007, Paul Collins wrote:
> 
> I got the message below on boot with 2.6.23-rc2 on my PowerBook.

It's a debug message, I think we need to remove it. It's trying to figure 
out what goes wrong with one particular machine, and I probably shouldn't 
have merged it for mainline.

Ignore it, it will be gone soon enough, and it should happen just once per 
boot.

		Linus
