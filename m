Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbYGEJoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbYGEJoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 05:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYGEJn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 05:43:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYGEJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 05:43:58 -0400
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Bastian Blank <bastian@waldi.eu.org>
Cc: Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080704225415.GA557@wavehammer.waldi.eu.org>
References: <20080704225415.GA557@wavehammer.waldi.eu.org>
Content-Type: text/plain
Date: Sat, 05 Jul 2008 10:44:01 +0100
Message-Id: <1215251041.3189.69.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-05 at 00:54 +0200, Bastian Blank wrote:
> Hi David
> 
> This patch is used by Debian since 2.6.25 to use request_firmware in the
> bnx2 driver. It lacks a small piece of inline patching for now.
> 
> The firmware files includes 7 firmwares with up to 3 sections plus some
> additional initialisation data. The corresponding firmware file
> generator is located at
> svn://svn.debian.org/kernel/dists/trunk/firmware-nonfree/bnx2/fwcutter.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>

Thanks for that. I had said I was going to stop working on drivers/net
for now though, so I'm not sure whether to apply it right now. Do you
have any more of these patches, for _non_ network drivers?

The firmware tree is intended to be obviously correct and uncontentious,
just updating drivers to what is common practice these days _anyway_,
with a few other things to make that easier for users.

Given that the majority of normal people are happy with it, we can cope
with a small amount of mostly-unfounded whinging, which we've got from
_both_ of the extreme ends of the spectrum as we try to find a sensible
path somewhere in the middle. But I don't want to provoke it further
right now, so I'm quite tempted to leave this patch until later, to
ensure that the tantrums from the network maintainers don't get in the
way of the rest of the real work and cleanups we're doing.

But if _Michael_ signs off on it, and if you can provide it in the form
used in the firmware-2.6.git tree, with the firmware files added into
the firmware/ subdirectory so they're still being shipped with the
kernel and the user doesn't have to go find them elsewhere, then I
suppose I'll probably take it.

I believe you no longer need to 'select FW_LOADER', btw.

-- 
dwmw2

