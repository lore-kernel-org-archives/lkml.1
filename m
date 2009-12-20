Return-Path: <linux-kernel-owner+w=401wt.eu-S1751352AbZLTFsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbZLTFsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 00:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZLTFsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 00:48:51 -0500
Received: from 1wt.eu ([62.212.114.60]:52803 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbZLTFsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 00:48:50 -0500
Date: Sun, 20 Dec 2009 06:48:47 +0100
From: Willy Tarreau <w@1wt.eu>
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [stable] Regression in 2.6.32.2: segfault on halt
Message-ID: <20091220054847.GF32739@1wt.eu>
References: <pan.2009.12.19.15.10.48.851500@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pan.2009.12.19.15.10.48.851500@googlemail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 04:10:49PM +0100, Holger Hoffstaette wrote:
> 
> After updating to 2.6.32.2 last night (using same config from .32.1) I
> noticed that "halt" now trips during shutdown and won't power the
> machine down any longer. This happens reproducibly on two completely
> different machines, so it looks like a generic problem and regression,
> since it did not happen in .32.1. Note that "reboot" works as expected -
> only "halt" crashes.

I have it working fine here. So your config helps to reproduce the issue.
Care to post it ?

> Stack dump in two parts (upper/lower half) can be found here:
> http://i.imgur.com/hDY8G.png
> http://i.imgur.com/bSmUN.png

it would have been nice for the readers to enhance the contrast a bit
before posting them.

> The topmost line (not captured) said something like "Illegal opcode 00
> (CPU #0)".
> 
> Let me know if you need anything else. I don't have time for full bisect,
> but am willing to try and back out select changesets as long as someone
> tells me which ones.. :)

Well, there were a number of x86 fixes in this version, maybe you'd like
to revert them as they may be a good common point between two machines ?
I personally find it easier to pick them all from Greg's announcement ;-)

Regards,
Willy

