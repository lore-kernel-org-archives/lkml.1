Return-Path: <linux-kernel-owner+w=401wt.eu-S965636AbXBGDZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965636AbXBGDZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 22:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965634AbXBGDZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 22:25:12 -0500
Received: from mf2.realtek.com.tw ([60.248.182.6]:2405 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965636AbXBGDZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 22:25:10 -0500
Message-ID: <45C94693.5090900@realtek.com.tw>
Date: Wed, 07 Feb 2007 11:25:07 +0800
From: =?UTF-8?B?6Kix5oGG5ZiJ?= <edward_hsu@realtek.com.tw>
User-Agent: Mozilla Thunderbird 1.0.2 (Windows/20050317)
X-Accept-Language: zh-tw, en-us, en, zh
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: Re: [PATCH 2.6.19.2] r8169: support RTL8169SC/8110SC
References: <45C2F390.4070805@realtek.com.tw> <20070203003952.GA22823@electric-eye.fr.zoreil.com> <45C6A8EC.5090201@realtek.com.tw> <20070206003130.GA18236@electric-eye.fr.zoreil.com> <45C7EB8A.1090700@realtek.com.tw> <20070206213827.GA25119@electric-eye.fr.zoreil.com>
In-Reply-To: <20070206213827.GA25119@electric-eye.fr.zoreil.com>
X-MIMETrack: Itemize by SMTP Server on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/07 =?Bog5?B?pFekyCAxMToyNTowNw==?=,
	Serialize by Router on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/07 =?Bog5?B?pFekyCAxMToyNTowNw==?=,
	Serialize complete at 2007/02/07 =?Bog5?B?pFekyCAxMToyNTowNw==?=
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Francois:

I think I didn't make it clear about the programming manuals for PCI-E ICs.

Due to several legal issues, Realtek won't put the programming guide on 
its website. However, Realtek does offer the programming guide if the 
customers need it. If you want to have a copy of it, please contact 
Realtek FAE<ryankao@realtek.com.tw>.

Best Regards,
Edward 2007/02/07

Francois Romieu 提到:

>edward_hsu@realtek.com.tw :
>[...]
>  
>
>>ANS_2:
>>So, do you think that it is a good idea to keep other vendos's PID and
>>DID in the part?
>>    
>>
>
>Yes.
>
>[...]
>  
>
>>ANS_2:
>>
>>Sure! You are right. RTL8110SC, RTL8111B and RTL8101E have modest
>>differences, now. However, RTL8101E is a PCI-E fast ethernet controller.
>>I don't think is a good idea to merge its Linux driver into r8168.c or
>>r8169.c. RTL8110SC is the final version of Realtek PCI gigabit ethernet
>>controller. Moreover, due to the increasing popularity of PCI-E, Realtek
>>is going to design several generations of PCI-E ethernet controllers to
>>satisfy customer requests. I have discussed this issue with my hardware
>>colleagues. They believe that both MAC register layout and tx/rx
>>descriptor layout will be changed a lot in new PCI-E ICs. Actually, they
>>already did. Therefore, the hardwares of RTL8111B(PCI-E gigabit
>>ethernet) and RTL8101E(PCI-E fast ethernet) will have frequent and
>>drastic changes. So, I think that it's a good moment to separate their
>>Linux drivers, and r8169.c can become stable.
>>    
>>
>
>Well, code and facts will tell. :o)
>
>Since you asked for questions:
>
>- will the ~7k limit for the jumbo frames be fixed ? One can hardly call
>  it a feature.
>
>- out of curiosity, did you try the current in-kernel r8169 driver with
>  a 8111B or a 8101E ?
>
>- is there any plan to open the programming manuals of the PCI-E chipsets ?
>
>  
>
