Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbXKRQti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbXKRQti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 11:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbXKRQtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 11:49:31 -0500
Received: from neopsis.com ([213.239.204.14]:49808 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750984AbXKRQta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 11:49:30 -0500
Message-ID: <47406CFF.8070306@dbservice.com>
Date: Sun, 18 Nov 2007 17:49:03 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: laptop reboots right after hibernation
References: <473730F6.2010900@dbservice.com> <20071118105214.GB7299@ucw.cz>
In-Reply-To: <20071118105214.GB7299@ucw.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.285,
	required 5, autolearn=spam, AWL 0.21, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>> echo disk > /sys/power/state
>>
>> successfully saves that state to the disk, but just as the laptop is
>> about to turn itself off, it reboots (successfully, so the
>> hibernation/resume process works well, even with X running! which is
>> awesome :) ). But I'd rather like the computer turned off after I
>> hibernate it. Where could the problem be?
>>
>> It's a new laptop, TP X61 tablet, I tried ubuntu (7.10, gutsy) for a few
>> days, both suspend and hibernate worked there (with one or two crashes,
>> probably due to X, I've read that the intel driver got some
>> suspend/resume improvements recently). Now I'm running gentoo, kernel
>> 2.6.24-rc2. I'm using newer versions of almost all software now compared
>> to the ubuntu system.
> 
> If it works in older ubuntu, you can probably do bisect. Does normal
> shutdown work? You can try platform vs. shutdown mode...

I forgot, normal shutdown (init 0) works, the 'shutdown' command fails
somewhere in the gentoo init scripts, but that has nothing to do with
the kernel. 'init 6' also works. Both regardless of where the notebook
is (dock or outside).

tom
