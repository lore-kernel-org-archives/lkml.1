Return-Path: <linux-kernel-owner+w=401wt.eu-S1757759AbYFBOYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbYFBOYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 10:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYFBOYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 10:24:11 -0400
Received: from gw.goop.org ([64.81.55.164]:34627 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYFBOYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:24:10 -0400
Message-ID: <48440264.5060506@goop.org>
Date: Mon, 02 Jun 2008 15:23:32 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Further percpu/pda unification?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I notice that there's now a unified asm-x86/percpu.h, and the pda is now 
a per-cpu variable.  But I also see that most of the stuff in percpu.h 
is 32-bit only: all the accessor macros, x86_read/write_percpu, etc.  Is 
there some reason why that can't be made common, or is it just that 
nobody has got around to it yet?

Thanks,
    J
