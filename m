Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYBSSTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYBSSTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYBSSTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:19:32 -0500
Received: from dbservice.com ([213.239.204.14]:57037 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755249AbYBSSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:19:30 -0500
Message-ID: <47BB1D9E.6030501@dbservice.com>
Date: Tue, 19 Feb 2008 19:19:10 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080211)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: hid device not claimed but /dev/input/event exists
References: <47BB041F.4060003@dbservice.com> <Pine.LNX.4.64.0802191751040.7699@twin.jikos.cz> <47BB1515.1070608@dbservice.com> <Pine.LNX.4.64.0802191846250.30955@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0802191846250.30955@jikos.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.257, required 5, AWL 0.24, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> Does anything appear in dmesg when you press those buttons? There should 
> be messages resembling the one you already have there:
> 
> drivers/hid/hid-core.c: report (size 8) (unnumbered)
> drivers/hid/hid-core.c: report 0 (size 8) =  00 00 28 00 00 00 00 00
> 
> and they should react to keys such as FastForward, Play, Mute, Volume Up, 
> etc.

This bug is in a completely different place then I thought! The speakers 
were plugged into the hub built into my monitor. I plugged it directly 
into the mainboard and voila, it works. Even g15daemon, the lcd driver, 
can now display a nice clock on the lcd.

Could it be that the hub is defective?

tom
