Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbXCTQAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbXCTQAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbXCTQAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:00:10 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55559 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbXCTQAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:00:08 -0400
Date: Tue, 20 Mar 2007 17:00:06 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: vojtech@suse.cz, dmitry.torokhov@gmail.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: strange keyboard lag after suspend testing
Message-ID: <20070320160006.GA14843@rhlx01.hs-esslingen.de>
References: <20070320153332.GA5533@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320153332.GA5533@elf.ucw.cz>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 20, 2007 at 04:33:32PM +0100, Pavel Machek wrote:
> Hi!
> 
> I was testing suspend in 2.6.21-rc4 a lot, and now... machine feels
> like someone added 50..100msec delay somewhere in keyboard
> handling. Mouse does not seem affected. /proc/interrupts seem to
> increase as they should, for both keyboard and mouse. Can someone
> reproduce it? Any ideas how to debug it?

Probably just asking the obvious:
it's not a trivial "failed to re-configure repeat rate upon resume"
(which one could rule out by running "kbdrate" again)
but a lag in some interrupt handler or somewhere else deeper, right?

Andreas Mohr
