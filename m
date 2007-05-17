Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbXEQR40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbXEQR40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbXEQR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:56:06 -0400
Received: from pool-72-92-171-78.albyny.east.verizon.net ([72.92.171.78]:50488
	"EHLO posidon.tmr.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758651AbXEQR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:56:05 -0400
X-Greylist: delayed 1960 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 May 2007 13:56:05 EDT
Message-ID: <464C8F88.80704@tmr.com>
Date: Thu, 17 May 2007 13:23:20 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Scheduler responsiveness under load
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am just running a new series of response tests, which I expect to send 
to the list today or tomorrow. It includes operating at some high 
(LA>20) loads, and gathering reproducible statistics. In the process I 
used the file completion feature while load was high, and noted that 
with sd0.48 typing the first characters and hitting tab was VERY slow 
compared to cfs12 or even fc6 recent release. The directory had about a 
dozen files, there was only one match, and I was just saving typing a 
long filename.

This was tested over three boots of sd0.48, cfs12, and fc6, as well as 
one boot of cfs9, and the problem was only with the most recent sd 
kernel I have built.

Hardware: Intel Core2duo 6600, 2.4MHz, 2GB mem, 600GB RAID5, kernel 
2.6.21 build with "make -j20" to generate the load.
