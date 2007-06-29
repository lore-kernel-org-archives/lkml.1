Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbXF2UvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbXF2UvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 16:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbXF2UvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 16:51:16 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:23119 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754871AbXF2UvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 16:51:15 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 16:51:15 EDT
X-YMail-OSG: GvXYGWIVM1kDKucRVxBh6kWVj2_p1y2DYTfWTK3T5rFcM3LoVLwbH1zSCbuuo7eC5VOCUuc3RzPkKzzLfUlMTwh5ocS2e6_CwPg-
Message-ID: <46856F24.5060407@andrei.myip.org>
Date: Fri, 29 Jun 2007 13:44:20 -0700
From: Florin Andrei <florin@andrei.myip.org>
Reply-To: linux-kernel@vger.kernel.org
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: how to determine if the noexec stack is defined by an application
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm reading Ingo's NX quick start document:

http://people.redhat.com/mingo/nx-patches/QuickStart-NX.txt

Quote:
"If an application defines a noexec stack then the kernel will enforce 
this executability, and all attempts to execute on the stack will be 
prevented by the hardware."

My question is related to the conditional "if an application". So it 
looks like it depends on the app.
Now, the OS/hardware combination that I'm using (RHEL4 WS 32 bit on 
AMD64 CPU - long story, don't ask) definitely enables NX:

# grep -i nx /var/log/dmesg
NX (Execute Disable) protection: active

But it's running a Web service which is a combination of C code and 
Tomcat/Java. I have no clue how to determine which portions specify a 
noexec stack and which don't.

In case it turns out some portions do not specify a noexec stack, my 
next question is how to get the application to create a noexec stack 
(assume I can make that request to the developers).


(please do NOT Cc me, I'm subscribed to the list)

-- 
Florin Andrei

http://florin.myip.org/
