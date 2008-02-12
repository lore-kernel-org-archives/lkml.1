Return-Path: <linux-kernel-owner+w=401wt.eu-S1761237AbYBLICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761237AbYBLICS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYBLICE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:02:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43047 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbYBLICD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:02:03 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B15257.80200@s5r6.in-berlin.de>
Date: Tue, 12 Feb 2008 09:01:27 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] firewire: fw-sbp2: fix I/O errors during reconnect
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.8110272bacc3f714@s5r6.in-berlin.de> <47B08F6B.2020502@redhat.com> <47B0AE54.8090602@s5r6.in-berlin.de> <47B1298D.2000600@redhat.com>
In-Reply-To: <47B1298D.2000600@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Stefan Richter wrote:
>> "perceived" unplugs can happen if a third node is slowly plugged in or out
[...]
> I wonder if there's any sort of
> guidance on this sort of thing in the firewire specs...

I am not aware of any.

The hardware related parts of the 1394a PHY layer spec have AFAIR
enhancements over 1394-1995 to avoid bursts of bus reset events when
connectors scrape into or out of the ports.  But what I saw on a few
occasions now were proper self ID complete events, not merely bus reset
events.  (The firewire stack only cares for self ID complete, therefore
multiple bus reset events before one self ID complete event aren't a
problem in the first place.  I don't know though whether these bursts of
bus resets which 1394a addressed had self ID complete events in them or
not.)
-- 
Stefan Richter
-=====-==--- --=- -==--
http://arcgraph.de/sr/
