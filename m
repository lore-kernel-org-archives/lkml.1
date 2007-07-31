Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbXGaMQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbXGaMQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757152AbXGaMQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:16:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbXGaMQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:16:23 -0400
Message-ID: <46AF27E6.5080008@zytor.com>
Date: Tue, 31 Jul 2007 08:15:34 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Ulrich Kunitz <kune@deine-taler.de>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Jan Kratochvil <honza@jikos.cz>,
       jakub@redhat.com
Subject: Re: Is PIE randomization breaking klibc binaries?
References: <20070720211300.GA21644@deine-taler.de> <46A131BF.4080404@zytor.com> <46A6624E.60003@redhat.com> <46A667BD.5080106@redhat.com> <20070724220053.GA20531@deine-taler.de> <46A68003.6060901@redhat.com> <46A68118.9080902@zytor.com> <20070725063243.GA25148@deine-taler.de> <Pine.LNX.4.64.0707311326090.26532@jikos.suse.cz> <46AF24B2.8070900@zytor.com> <Pine.LNX.4.64.0707311418040.26532@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0707311418040.26532@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 31 Jul 2007, H. Peter Anvin wrote:
> 
>>> I just now quickly tried to with klibc-1.5 on i386 with the 
>>> PIE-randomization patched kernel, and it seems to load static 
>>> libraries fine. I just downloaded klibc-1.5, built it, and executed a 
>>> few of the programs in usr/utils/static, all of them worked. Does this 
>>> also work for you and you are experiencing the problems solely when 
>>> the binaries are being run from initramfs during boot? I will test 
>>> more shortly (on x86_64, directly from initramfs) in order to 
>>> reproduce.
>> What about shared binaries?
> 
> Works for me too on the pie-randomization patched kernel.
> 
> So it seems to me that either it is something x86_64 specific or 
> initramfs-specific. Will try to reproduce it.
> 

My guess would be the former, rather than the latter.  I haven't had a 
chance to reproduce it myself yet (I'm on the road), but I will try to 
get the time tomorrow.
