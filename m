Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZBJBS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZBJBS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZBJBSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:18:49 -0500
Received: from gw.goop.org ([64.81.55.164]:41233 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbZBJBSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:18:48 -0500
Message-ID: <4990D5F5.9030409@goop.org>
Date: Mon, 09 Feb 2009 17:18:45 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 08/11] x86: use asm .macro instead of cpp #define in entry_32.S
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-9-git-send-email-tj@kernel.org> <4990774E.5080206@goop.org> <4990D4E3.1010109@kernel.org>
In-Reply-To: <4990D4E3.1010109@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hmm... I originally did the conversion because I had some .if trick in
> SAVE_ALL which got removed later.  Even after the removal, it
> generally looked like a good idea as x86_64 asm was primarily using
> .macro too.  I do like being able to see the post-processing output of
> cpp too but for assembler disassembling the output often seem to give
> enough clue,
That's assuming that the file assembles.  But if you're trying to 
assemble and the best error the assembler comes up with is "bad operand" 
on the line where you're using the macro, its extremely frustrating 
trying to work out where the problem actually lies.

    J
