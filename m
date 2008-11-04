Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbYKDLrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbYKDLrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 06:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYKDLrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 06:47:43 -0500
Received: from lazybastard.de ([212.112.238.170]:44575 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYKDLrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 06:47:43 -0500
Date: Tue, 4 Nov 2008 12:47:33 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ext2/3 vs. kingston 32G SD card
Message-ID: <20081104114733.GA16036@logfs.org>
References: <20081104110225.GB4514@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081104110225.GB4514@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 November 2008 12:02:25 +0100, Pavel Machek wrote:
> 
> I got 32GB kingston SD card, and am using it with ext2 for storing git
> trees etc.
> 
> Unfortunately, every time I run fsck, I get rather nasty corruption. 
> I switched it to ext3 now, but I believe I have seen corruption even
> on volume marked clean, which should be impossible from user error.
> 
> If I suspect wrong block device, what are useful tests to run there?

Not likely in your case, but a number of counterfeited devices are on
the market.  They contain a much smaller chip inside than is advertised
plus some logic to return 0x00 when reading from non-existent memory.

To test for this, simply write 0xff to the complete device and read it
back.  'hd' is useful, as it compressed the output into four lines for a
good device and a bit more when you bought crap.

Jörn

-- 
Man darf nicht das, was uns unwahrscheinlich und unnatürlich erscheint,
mit dem verwechseln, was absolut unmöglich ist.
-- Carl Friedrich Gauß
