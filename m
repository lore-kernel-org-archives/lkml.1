Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbXGCPzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbXGCPzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753789AbXGCPy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:54:59 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:34151 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXGCPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:54:58 -0400
Message-ID: <468A7145.7030606@nortel.com>
Date: Tue, 03 Jul 2007 11:54:45 -0400
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20060130 Red Hat/1.7.12-1.4.2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: any known issues with leap seconds in 2.6.10?
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Jul 2007 15:54:55.0634 (UTC) FILETIME=[80242F20:01C7BD8A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm just wondering if anyone knows of issues with leap second handling in 
2.6.10.  We just had a field incident where a couple of quad-x86 machines went 
down at just before midnight (UTC) on June 30th...which is when leap seconds 
would normally be applied.

 From our logs it looks like something went crazy while holding the xtime lock.

If anyone knows of issues with that code I'd love to hear about it.

Thanks,

Chris
