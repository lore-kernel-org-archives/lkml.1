Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYJXXH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYJXXH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYJXXHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:07:51 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:52668 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750785AbYJXXHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:07:50 -0400
Date: Sat, 25 Oct 2008 01:07:48 +0200
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MCEs
Message-ID: <20081024230748.GA21365@codeblau.de>
References: <20081024124502.GA9425@codeblau.de> <87r66598eq.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r66598eq.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's some sort of hardware problem, debugging it typically
> either involves fixing the cooling or exchanging components.

Using an older kernel I get actual MCE messages that I can write down
and decode using mcelog.

It looks like the MCE handler is buggy in current kernels and will cause
a panic instead of the MCE messages (or maybe in addition to and the
panic obscures them by scrolling them out of my 80x25 screen).

Is there a howto or wiki somewhere on how to parse mcelog decoded
messages?

Felix
