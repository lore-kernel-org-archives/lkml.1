Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbXGDJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbXGDJL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbXGDJLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:11:20 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:56208 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbXGDJLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:11:19 -0400
Message-ID: <468B642D.9030109@alcatel-lucent.com>
Date: Wed, 04 Jul 2007 17:11:09 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Big sized packets have been dropped strangly
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2007 09:11:14.0456 (UTC) FILETIME=[459B7980:01C7BE1B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,

I got a strange problem recently but no ideas, so to post the question 
here. We have a FPGA what finish ATM AAL5 to ethernet frame, and CPU 
receives IP packets from it. The interface based on the FPGA (called 
sar0) has been bound with several IP addresses. When the MTU of the 
interface is configurated to 1500, trivial packets can be received, but 
big-sized packets are dropped. If the MTU is increased to 9500, 
everything is ok except the NFS connection. We mounted with another 
machine through sar0. When the MTU is 9500, the speed of the NFS becomes 
very very slow (it almost took 10 minutes to transfer 100KB files).

I don't know why it is and how to solve it. Any suggestions are appreciated!

Thanks,
Gavin
