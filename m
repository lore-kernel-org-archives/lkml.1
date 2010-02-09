Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0BIQ5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:57:08 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:53879 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0BIQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:57:04 -0500
Message-ID: <4B71927D.6030607@nortel.com>
Date: Tue, 09 Feb 2010 10:51:09 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: tracking memory usage/leak in "inactive" field in /proc/meminfo?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2010 16:56:56.0639 (UTC) FILETIME=[E34A7CF0:01CAA9A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm hoping you can help me out.  I'm on a 2.6.27 x86 system and I'm
seeing the "inactive" field in /proc/meminfo slowly growing over time to
the point where eventually the oom-killer kicks in and starts killing
things.  The growth is not evident in any other field in /proc/meminfo.

I'm trying to figure out where the memory is going, and what it's being
used for.

As I've found, the fields in /proc/meminfo don't add up...in particular,
active+inactive is quite a bit larger than
buffers+cached+dirty+anonpages+mapped+pagetables+vmallocused.  Initially
the difference is about 156MB, but after about 13 hrs the difference is
240MB.

How can I track down where this is going?  Can you suggest any
instrumentation that I can add?

I'm reasonably capable, but I'm getting seriously confused trying to
sort out the memory subsystem.  Some pointers would be appreciated.

Thanks,

Chris
