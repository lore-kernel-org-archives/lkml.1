Return-Path: <linux-kernel-owner+w=401wt.eu-S1030475AbXBOSax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030475AbXBOSax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030463AbXBOSax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:30:53 -0500
Received: from uslec-66-255-149-99.cust.uslec.net ([66.255.149.99]:4203 "EHLO
	mail.wegener.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030475AbXBOSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:30:52 -0500
X-Greylist: delayed 956 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 13:30:51 EST
Message-ID: <45D4A692.7090108@wegener.com>
Date: Thu, 15 Feb 2007 13:29:38 -0500
From: Mike Panetta <m.panetta@wegener.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: APIC priorities, can they be changed?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am not on the list (corperate email sucks) so please CC any replies to 
me.  Thanks.

I am working on a project that has run in to what seems to be an 
interrupt priority problem.  We switched mainboards in our product and 
went from a system where the EHCI controller IRQ was of a fairly high 
priority to one where its the lowest in the system.  Now we cannot get 
the data off our USB device in time and we drop alot of data.  I was 
hoping someone here may have a simple(ish) solution to the problem.

I have seen the preempt patches, but they touch a lot of files, and we 
have gone through testing with the 2.6.16.19 kernel and do not wish to 
change, and we cannot find a version of the patch for this kernel. Is 
there something smaller/simpler I can do?  My understanding is the 
priority in the APIC is set in software via the interrupt vector number 
(higher numbers have lower priority) is this true?  If so, how hard 
would it be for me to just change the vector numbers around?

Ideally I would love to switch to the 2.6.20 kernel and use the preempt 
patch, but I doubt we have the time for that.

Thanks,
Mike
