Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbXBFQ5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbXBFQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932930AbXBFQ5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:57:24 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:63936 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbXBFQ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:57:23 -0500
Message-ID: <45C8B362.3000402@nortel.com>
Date: Tue, 06 Feb 2007 10:57:06 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: legal to call tasklet_schedule() from within schedule()?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Feb 2007 16:57:11.0522 (UTC) FILETIME=[D82E3420:01C74A0F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I'm noodling around with some way to print out error messages from 
within the scheduler itself.  One way that I'm considering is to copy 
messages to a static memory buffer and then trigger a tasklet to do the 
actual printing.  The question I had was whether it's actually legal to 
call tasklet_schedule() from within the schedule() function, or whether 
that could lead to bad things.  Can anyone give me a definitive 
statement on this?

Does anyone have any other suggestions on the best way to do this?

Thanks,

Chris
