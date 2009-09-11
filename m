Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZIKSLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZIKSLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbZIKSL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:11:28 -0400
Received: from web32408.mail.mud.yahoo.com ([68.142.207.201]:48000 "HELO
	web32408.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754479AbZIKSL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:11:28 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 14:11:28 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=JpLBN+wyFPVRaHh7706jWY4v8xhHUgv2acSeMmSP0j9t+a5ksW44bcEOs/9QLkAmm89gvfFLsrml+xpztR4pZkg8diXJZahX3tJSSFZyW+dY2b3x2p6oTv6SlcOu8UHgwX1STCWWgowlxgvN/h4GTAjFZsjARxJ13JkbKjd/TkU=;
Message-ID: <12538.96333.qm@web32408.mail.mud.yahoo.com>
X-YMail-OSG: eDG6zQ0VM1m.mEqJN_.lYblMrFmkpuRom8SaVOOQwYqn9D90DjANMAhDZzBkwCWjeATSgpckTXMh9ZbNIMdYIhvIrmq7XWxnQcHlHZnaWpzEks9IqxH8YFQErD.U8qDY4vkf44F6L42qdp7qTNDOXraVWHOAw3Jw.N.4H3dbCdI7vwOK3LVhNTdEaqS1PS5mz46ccKhanXYQv0ydpOgnDLCQ4m4gg.Zn7sgxEHkWhN8CLrE0uOdpv3tKbPhMYznVKeqW_Plx9aKzEjTiljcrhjTNOuMcVU8G_oCwdaoosZufiPSYsfRx9FdY.vhoIFc3Kofim7t12w7r4OS0rfR8FjeC29w4rHlD0sQ-
X-Mailer: YahooMailClassic/6.1.2 YahooMailWebService/0.7.338.2
Date: Fri, 11 Sep 2009 11:04:49 -0700 (PDT)
From: Anil kumar <anils_r@yahoo.com>
Subject: hibernate takes long time with huge file transfers
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running a huge file transfer by using simple dd command. I see that the process state of this dd is "D" uninterruptible sleep. Now I hibernate the system.

what I observe is that hibernate takes long time to complete. Looks like its waiting for the "dd" command to complete. 
My understanding is that since the process is in uninterruptible sleep, hibernate is not able to stop the task.

Question:
1. Does hibernation work this way wherein it waits for the process to complete and then hibernate. Especially if the process is in uninterruptible sleep state.
2. What if the process is not in uninterruptible sleep?
3. Does sync'ing also adds to longer durations? 

Thanks in advance for the help.

With regards,
   Anil


      
