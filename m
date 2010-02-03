Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab0BCTYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:24:41 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35050 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab0BCTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:24:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=j89/IAf30hDte8wid3Ew1jzvL0rPAJDPsGvWw+Vmtvyx0Zw3fVjMdZieCgIgKmOqeU
         n9GICKAs2vSsLMO9afTQmVpj6TD5lg7ScM83f+b0LsZVGNHSu819oEFprV0f+lpwv7MJ
         mk2vZJ2oGi1REpX4SNjd98Jo1o5SIDuO4Nl5k=
Message-ID: <4B69CDCB.5020608@gmail.com>
Date: Wed, 03 Feb 2010 11:26:03 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Dan Carpenter <error27@gmail.com>, bernhard.kaindl@gmx.net,
       Thomas Gleixner <tglx@linutronix.de>,
       linux1394-devel@lists.sourceforge.net, Rafael Wysocki <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiderman@xmission.com, hpa@zytor.com
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug	 #14487]
 PANIC: early exception 08 rip 246:10	 error	ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera> <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com> <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com> <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com> <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com> <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com> <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de> <4B68D4CA.2010803@gmail.com> <4B694D5C020000780002D6DA@vpn.id2.novell.com>
In-Reply-To: <4B694D5C020000780002D6DA@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jan,

Thanks for that info, after looking at
arch/x86/kernel/head_64.S
I'm thinking this is a grub2 issue.

 From what I remember while building this system
I used ubuntu as the host, built grub2 from git
then once being able to boot, figured it was all good.

Just to see, I'll go and leave the kernel as it is,
build grub2 again, just to make sure.
(maybe there's something happening with it because
grub2 is built pure64, anything 32bit wont work
(could be wrong though)) i.g. if the kernel does 32bit something
then changes to 64bit and in the meantime grub2 can only see 64bit then 
maybe this is what I'm hitting.

Justin P. Mattock
