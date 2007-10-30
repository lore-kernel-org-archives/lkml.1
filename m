Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbXJ3Izs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbXJ3Izs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXJ3Izl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:55:41 -0400
Received: from toro.web-alm.net ([62.245.132.31]:38798 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbXJ3Izk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:55:40 -0400
X-Greylist: delayed 4515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 04:55:40 EDT
Message-ID: <4726DF66.4000000@osadl.org>
Date: Tue, 30 Oct 2007 08:38:14 +0100
From: Carsten Emde <Carsten.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: David Brown <dmlb2000@gmail.com>, kvm-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] 2.6.23.1-rt4 and kvm 48
References: <9c21eeae0710290709x527cf4fcq52bb410907ff496@mail.gmail.com> <4726B088.1010709@qumranet.com>
In-Reply-To: <4726B088.1010709@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> David Brown wrote:
>> I thought I'd try out the realtime patch set and it didn't work at all
>> with kvm. The console didn't dump anything and the system completely
>> locked up.
Up to now, the unmodified kvm module never worked with any RT kernel. 
This would only change, if RT patched kernels were routinely used in the 
kvm release tests which is, for the time being, not the case.

However, tglx once provided a hand-crafted kvm version that can be used 
together with a selected RT kernel -> see "Latest Stable" 
(http://www.osadl.org/Latest-Stable.latest-stable-realtime-kernel.0.html) 
realtime kernel. It is based on kernel 2.6.21.6-rt21 and kvm-28.

We used these modules to carry out a number of "proof of concept" tests 
which were very successful. The realtime capabilities of the host system 
remained unchanged irrespective of whether the kvm guest system (no 
graphics) was running or not. This was even the case while the guest 
system was booting.

We are planning to provide another "Latest Stable" realtime kernel 
within the next month or so. It will probably be based on kernel 2.6.23.

	--cbe
