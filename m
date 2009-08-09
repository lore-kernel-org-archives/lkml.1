Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZHIOCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZHIOCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 10:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZHIOCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 10:02:43 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:34216 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZHIOCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 10:02:43 -0400
Message-ID: <4A7ED700.9080407@pardus.org.tr>
Date: Sun, 09 Aug 2009 17:02:40 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
References: <20090808194733.38406075@neptune.home>
In-Reply-To: <20090808194733.38406075@neptune.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont wrote:
> I tried bisecting this but bisect did end up on a fully unrelated commit
> (which is not even being compiled into my kernel).
> Possibly the failed bisect could be related to mis-classified kernel
> panic/hang while pulling the USB cable (there were two such panics for the
> whole iteration)?
>
> There are quite a few patches touching tty, ttyUSB and friends between
> rc4 and now so pretty hard to guess on the correct one.
>
> The oops always happens when I disconnect the USB serial console (here
> the one built into Marvell SheevaPlug) while having minicom connected
> to it.
> During the bisection for the last few bad iterations minicom got killed
> (segfault), the bad ones on the iteration left a minicom zombie in 'D'
> state.
>
> Regards,
> Bruno
>
>   

That may be a related/possible fix for that,

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b68f2fb9e73f46037fbeca5fbd4ae8a7ddd8ef6b
