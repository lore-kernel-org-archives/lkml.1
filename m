Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYK0AAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYK0AAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYK0AAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:00:22 -0500
Received: from main.gmane.org ([80.91.229.2]:44557 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYK0AAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:00:22 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Panic:  NMI Watchdog detected LOCKUP on CPU
Date: Wed, 26 Nov 2008 18:00:11 -0600
Message-ID: <492DE30B.4080300@shaw.ca>
References: <20081126231213.271070@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <20081126231213.271070@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Menke wrote:
> Hi List,
> 
> I hope this is not the too wrong place to ask a question about the issue in the subject as the problem arises with a rather old 2.6.15 Kernel of an Ubuntu 6.06 Installation. But as nobody has even looked at the report I filed in the Ubuntu Bug database for 2  months. I try my luck here. I got a HP ML 350 G5 Server running and I occasionly receive kernel panics (vary from 1 time per week up to 2 months). I just want to get any pointer if this may be a hardware issue or a kernel issue, which in turn may have been fixed in a later version. As only Red Hat is supported by HP it will get rather difficult to get someone on service (we have an extended On site Warranty) an replace parts as we're running Ubuntu on the server and 2nd the diagnostic CD (Smart Start) shows that everything is ok (That
>   of course doesn't mean, i trust these tools to much).
> 
> One thing I noted is that always the smbd process occurs in the panic log, the second thing is that it seems that it is unrelated to the system load as it happened 1 time during full working hours and another time during the night whe the server was absolutly idle (The server in turn does not do much more than a load of 20% either).
> 
> So here is the log I caputred via syslogd from netconsole and the dmesg, please apologize that due to syslog some lines are split across multiple lines, which show actually up as one on the console
> 
> Hope someone get me anywhere
> 
> Carsten
> 
> 

Normally server-class hardware doesn't cause these kinds of symptoms 
from hardware problems, they usually spew NMIs, etc. but it's not 
impossible. 2.6.15 is pretty ancient though. Can you try a newer kernel?

