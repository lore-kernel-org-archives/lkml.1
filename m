Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880Ab0AZTJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0AZTJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646Ab0AZTJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:09:05 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:59500 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab0AZTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:09:04 -0500
Message-ID: <4B5F3C9C.3050908@nortel.com>
Date: Tue, 26 Jan 2010 13:03:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: which fields in /proc/meminfo are orthogonal?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2010 19:08:57.0725 (UTC) FILETIME=[02D7CAD0:01CA9EBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

We have a system (2.6.27 based) which seems to be increasing its memory
consumption by several MB an hour.  Summing up Pss for all maps in all
processes doesn't seem to explain it, so I'm looking at the kernel.

I've backported the kmemleak functionality.  It's self-test module shows
leaks so I know it's working, but it doesn't report any leaks that would
correspond to the memory increase.

I'm currently trying to figure out which of the entries in /proc/meminfo
are actually orthogonal to each other.  Ideally I'd like to be able to
add up the suitable entries and have it work out to the total memory on
the system, so that I can then narrow down exactly where the memory is
going.  Is this feasable?

I'll keep reading the code but if anyone happens to know this already
I'd appreciate some assistance.

Thanks,

Chris
