Return-Path: <linux-kernel-owner+w=401wt.eu-S1030348AbXBZRSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348AbXBZRSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 12:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030349AbXBZRSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 12:18:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57276 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030348AbXBZRSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 12:18:38 -0500
X-Greylist: delayed 1548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 12:18:38 EST
Message-ID: <45E3105F.4070303@charter.net>
Date: Mon, 26 Feb 2007 10:52:47 -0600
From: Brian Johnson <bjj4@charter.net>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: PIO port width on various archs?
References: <45E14F9D.3050502@qumranet.com> <1172464067.12245.4.camel@diesel> <45E27A94.3020400@qumranet.com>
In-Reply-To: <45E27A94.3020400@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Hollis Blanchard wrote:
>> On Sun, 2007-02-25 at 10:58 +0200, Avi Kivity wrote:
>>   
>>> I'm changing the kvm userspace interface to be more friendly to other 
>>> archs.  One issue is the PIO port size.  x86 uses 16 bits to hold the 
>>> port size (64K ports).  Is that an issue for other archs?
>>>
>>> I guess I could change it to __u32, but it's better to know what various 
>>> architectures actually require.
>>>     
>> PowerPC doesn't have any such concept; access to ISA PIO is done by
>> having the bridge translate a particular range of MMIO accesses as PIO.
>> I'm no expert, but I don't know of any mainstream processor other than
>> x86 that supports PIO.
>>   
> 
> I think ia64 does, but it's probably exactly the same as x86.

IA64 uses a special memory range which is translated into I/O port 
accesses by the CPU hardware (as opposed to the I/O bridge.)  Section 
10.7 of volume 2 of the Itanium SDM has the details.  Only 64k of I/O 
ports is supported.

Brian J. Johnson
