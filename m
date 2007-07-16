Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbXGPJFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbXGPJFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXGPJFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:05:14 -0400
Received: from fep01.mfe.bur.connect.com.au ([203.63.86.21]:51019 "EHLO
	fep01.mfe.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753825AbXGPJFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:05:13 -0400
X-Greylist: delayed 531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 05:05:12 EDT
Message-ID: <469B31E8.6050906@murdoch.edu.au>
Date: Mon, 16 Jul 2007 16:52:56 +0800
From: "Z. Cliffe Schreuders" <c.schreuders@murdoch.edu.au>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Including STRTOK_R in a LSM
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am aware strtok was removed from the kernel in 2002. However strtok_r 
is more desirable than strsep as I do not want to know about 'blank 
fields' (2 consecutive delimiters). Is it acceptable to simply include 
the strtok_r code in my security module? or should I create a wrapper 
for strsep to ignore blanks?

Thanks,

Z. Cliffe Schreuders

Please cc me.
