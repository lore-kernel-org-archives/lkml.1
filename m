Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbXLORNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbXLORNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 12:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbXLORNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 12:13:16 -0500
Received: from palrel12.hp.com ([156.153.255.237]:59782 "EHLO palrel12.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbXLORNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 12:13:15 -0500
Message-ID: <47640B1C.7080506@hp.com>
Date: Sat, 15 Dec 2007 12:13:00 -0500
From: Mark Seger <Mark.Seger@hp.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Update on collectl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last summer I announced that I had released a performance monitoring 
tool called collectl and just wanted to let people know I've since 
significantly improved the website at http://collectl.sourceforge.net/ 
to include examples, a block diagram and even included a couple of pages 
on some interesting kernel problems it helped identify, though they've 
since been addressed.  Perhaps one of the more interesting ones is that 
not too long ago, and I'm really not sure when it actually got fixed, it 
was impossible to accurately measure network traffic at 1 second 
intervals and worse, you'd periodically see double the actual rate 
reported.   Try it out on an older kernel and see for yourself!  
However, since collectl can monitor at subsecond intervals you could 
monitor those older kernels at 0.9765 seconds and see accurate data.  
Rather than me try to explain it, take a look at 
http://collectl.sourceforge.net/NetworkStats.html to read more.

I think a couple of other features I may not have said enough about is 
monitoring Infiniband and Lustre performance, for which I don't believe 
there are any good tools available.  You can get IB data from asking the 
switch, but you can't easily get it from the local system.  There is 
actually a wealth of information Lustre provides but no good tools to 
mine it.  Now there is.  With collectl you can see a second-by-second 
(or any other interval you prefer) snapshot of just what is happening to 
these key resources and can even watch the load on cpu, memory and 
network at the same time.  If you prefer, and most people do, just run 
collectl as a service and it will maintain a set of compressed rolling 
logs containing 10 second samples (all customizable) and do it all at 
<0.1% of system overhead.

Enough rambling already.  Download it and see for yourselves...

-mark


