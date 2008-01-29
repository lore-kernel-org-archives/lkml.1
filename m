Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYA2Mou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYA2Mou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYA2Mon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:44:43 -0500
Received: from michael.checkpoint.com ([194.29.32.68]:58983 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbYA2Mom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:44:42 -0500
X-Greylist: delayed 1884 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 07:44:41 EST
Message-ID: <479F1866.4050007@checkpoint.com>
Date: Tue, 29 Jan 2008 14:13:26 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I have a 32-bit user land application which sends an IOCTL to a 64-bit 
Kernel module. I have a few different cmd codes that I can send through 
the IOCTL. For some reason I seem to always get the same IOCTL cmd from 
user land, no matter what the ioctl() call is given. This cmd code that 
I get has some bytes (W/R and the module code) that are OK, but the rest 
is just garbage or zeros. This was originally a 32-bit system, and we 
are no converting the Kernel module to 64-bit, so maybe there's 
something special for 32-64 communication that miss.


I am working on Linux Kernel v2.6.18.


Thanks

