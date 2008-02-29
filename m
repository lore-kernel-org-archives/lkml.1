Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYB2HTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYB2HTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 02:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbYB2HTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 02:19:06 -0500
Received: from eusa.axetic.com ([194.242.114.93]:54408 "EHLO eusa.axetic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbYB2HTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 02:19:05 -0500
X-Greylist: delayed 1535 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 02:19:04 EST
Message-ID: <47C7ABE3.6080004@axetic.com>
Date: Fri, 29 Feb 2008 07:53:23 +0100
From: Yannick <yannick.dirou@axetic.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [Bug 10071] kernel hang in inet_init (PREEMPT_RCU problem)
References: <bug-10071-11547@http.bugzilla.kernel.org/> <20080228205303.261D311D108@picon.linux-foundation.org> <20080228213457.GA2770@ami.dom.local> <20080229005823.GF14104@linux.vnet.ibm.com> <20080229043235.GA25167@linux.vnet.ibm.com>
In-Reply-To: <20080229043235.GA25167@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(In reply to comment #20)
 > Reply-To: paulmck@linux.vnet.ibm.com
 >
 > Would you be willing to try your test again after applying the
 > patch in http://lkml.org/lkml/2008/2/2/11 and rebuilding your
 > kernel?
 >
 > This patch does not appear to be in 2.6.25-rc3.  :-(
 >
 > I am reposting this patch separately.
 >
 >                                                         Thanx, Paul

Congratulations Paul and thanks a lot to Jarek , It works,
no more hang or slow boot :
[1.061675] Calling initcall 0xc03b8e10: inet_init+0x0/0x3ba()
[1.061895] NET: Registered protocol family 2
[1.339007] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[1.339470] TCP established hash table entries: 131072 (order: 8, 1048576 
bytes)
[1.340375] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[1.349809] TCP: Hash tables configured (established 131072 bind 65536)
[1.349906] TCP reno registered
[1.098514] initcall 0xc03b8e10: inet_init+0x0/0x3ba() returned 0.
[1.098604] initcall 0xc03b8e10 ran for 32 msecs: inet_init+0x0/0x3ba()

Yannick
