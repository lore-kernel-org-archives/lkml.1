Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXDCHZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXDCHZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 03:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXDCHZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 03:25:36 -0400
Received: from bay0-omc1-s18.bay0.hotmail.com ([65.54.246.90]:65159 "EHLO
	bay0-omc1-s18.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492AbXDCHZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 03:25:35 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 03:25:35 EDT
Message-ID: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl>
X-Originating-IP: [88.114.147.249]
X-Originating-Email: [paapaa125@hotmail.com]
From: "Paa Paa" <paapaa125@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: Lower HD transfer rate with NCQ enabled?
Date: Tue, 03 Apr 2007 07:11:28 +0000
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
X-OriginalArrivalTime: 03 Apr 2007 07:11:29.0956 (UTC) FILETIME=[4D4EC640:01C775BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using Linux 2.6.20.4. I noticed that I get lower SATA hard drive 
throughput with 2.6.20.4 than with 2.6.19. The reason was that 2.6.20 
enables NCQ by defauly (queue_depth = 31/32 instead of 0/32). Transfer rate 
was measured using "hdparm -t":

With NCQ (queue_depth == 31): 50MB/s.
Without NCQ (queue_depth == 0): 60MB/s.

20% difference is quite a lot. This is with Intel ICH8R controller and 
Western Digital WD1600YS hard disk in AHCI mode. I also used the next 
command to cat-copy a biggish (540MB) file and time it:

rm temp && sync && time sh -c 'cat quite_big_file > temp && sync'

Here I noticed no differences at all with and without NCQ. The times (real 
time) were basically the same in many successive runs. Around 19s.

Q: What conclusion can I make on "hdparm -t" results or can I make any 
conclusions? Do I really have lower performance with NCQ or not? If I do, is 
this because of my HD or because of kernel?

Best regards,
Paapaa

_________________________________________________________________
Express yourself instantly with MSN Messenger! Download today it's FREE! 
http://messenger.msn.click-url.com/go/onm00200471ave/direct/01/

