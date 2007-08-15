Return-Path: <linux-kernel-owner+w=401wt.eu-S936403AbXHOUnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936403AbXHOUnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbXHOUna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:43:30 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:6211 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753262AbXHOUn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:43:29 -0400
Message-ID: <46C36580.5030006@cfl.rr.com>
Date: Wed, 15 Aug 2007 16:43:44 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <633206.92836.qm@web52512.mail.re2.yahoo.com>
In-Reply-To: <633206.92836.qm@web52512.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 20:43:44.0222 (UTC) FILETIME=[F88C1FE0:01C7DF7C]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15364.001
X-TM-AS-Result: No--8.466900-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> 
> Kyle - you are still missing the point. chmod goes
> away. File permissions goes away. Directories as you
> know them goes away. 

You are missing the point Marc... open()ing a file will have to perform 
a number of these pattern matches to decide if it is allowed or not... 
this would be a HUGE overhead.

