Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbZCRLrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbZCRLrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbZCRLrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:47:39 -0400
Received: from india.einfochips.com ([203.88.139.151]:31395 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754903AbZCRLri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:47:38 -0400
Message-ID: <49C0DE95.3060402@einfochips.com>
Date: Wed, 18 Mar 2009 17:14:21 +0530
From: Viral Mehta <viral.mehta@einfochips.com>
Organization: eIbfochips Ltd.
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel_thread question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

//My thread routine
int my_thread(void*)
{
    if(printk("blah"))
        return 5; //WHERE THE HELL THIS VALUE GOES !! ?? !! HOW CAN I 
SEE ITS RETURN VALUE ??? PLEASE SUGGEST
    else
       return 0;
//WHERE THE HELL THIS RETURN VALUE GOES !! ?? !! HOW CAN I SEE ITS 
RETURN VALUE ??? PLEASE SUGGEST
//RETURNED 5 or 0 ?? I am amused
}

//my init module
int mod_init()
{
    ...
    int i;
    i = kernel_thread ((void *)my_thread, NULL, 0); //RETURNS NEW PROCESS ID
    ...
}

There is one doubt. Whatever that kernel_thread has started and it 
completes and returns some value. How can I see that value?
-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
__________________________________________________________________________
 
