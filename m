Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXISTsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXISTsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbXISTsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:48:33 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:61013 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXISTsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:48:32 -0400
Message-ID: <46F17D03.9090801@nortel.com>
Date: Wed, 19 Sep 2007 13:48:19 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: davids@webmaster.com
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
References: <MDEHLPKNGKAHNMBLJOLKKEIPGOAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEIPGOAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2007 19:48:23.0687 (UTC) FILETIME=[09CFF170:01C7FAF6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:

> Nonsense. The task is always ready-to-run. There is no reason its CPU should
> be low. This bug report is based on a misunderstanding of what yielding
> means.

The yielding task has given up the cpu.  The other task should get to 
run for a timeslice (or whatever the equivalent is in CFS) until the 
yielding task again "becomes head of the thread list".

Chris
