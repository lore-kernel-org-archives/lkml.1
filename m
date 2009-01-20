Return-Path: <linux-kernel-owner+w=401wt.eu-S1762398AbZATRiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762398AbZATRiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZATRh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:37:56 -0500
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:47750 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753292AbZATRhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:37:55 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 12:37:55 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=celticblues.com;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding:X-Antivirus:X-Antivirus-Status:X-Identified-User;
	b=mmJ+UEgm/eAzHfZwbgS/qgzdRq1r+A/lz/XGIFTf4diWrtrcxQeCN/mJYVmP3AKhToQnoFQE3PKWadNzDUM9VDyYu1ie9ZfFQXSHJIjTRO6/GXMyI5EzSK/cRm4N0EG3;
Message-ID: <49760A60.7040804@celticblues.com>
Date: Tue, 20 Jan 2009 11:31:12 -0600
From: linux <linux@celticblues.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: disabling interupts 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090119-0, 01/19/2009), Outbound message
X-Antivirus-Status: Clean
X-Identified-User: {989:box326.bluehost.com:peddycoa:celticblues.com} {sentby:smtp auth 24.214.236.85 authed with edpeddycoart@celticblues.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please advise if this question is OT.  (If so, where can I post it or 
read more about said topic?)

I have an application that grabs frames from a frame grabber.  It is 
dropping frames, sometimes, 30 frames at a time.  I suspect this is 
occuring due to background tasks or something like that interupting the 
app.   In the future I may go to a hard RT linux, but for now, I just 
have time to try to reduce the number and frequency of frame drops. 

I read on some linux websites that one can disable interrupts to 
increase performance and/or reduce latencies. 

My questions are

1.  Is this an acceptable practice?  If not, what are my other options?

2.  How can I do this?  

Would I use:
    void local_irq_save(unsigned long flags);
    void local_irq_restore(unsigned long flags);


3.  What interupts should I consider disabling?

Ed
