Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbXEZOkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbXEZOkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbXEZOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:39:58 -0400
Received: from gw.ac.upc.edu ([147.83.30.3]:57399 "EHLO gw.ac.upc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbXEZOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:39:57 -0400
In-Reply-To: <200705261505.38109@gj-laptop>
References: <200705261505.38109@gj-laptop>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EC7004A7-D0AC-47F1-8FB7-84B8071515D2@ac.upc.edu>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: "Julio M. Merino Vidal" <jmerino@ac.upc.edu>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Date: Sat, 26 May 2007 16:39:52 +0200
To: Tommy Vercetti <vercetti@zlew.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/05/2007, at 15:05, Tommy Vercetti wrote:

> Hi folks,
>
> I was trying to get answer to my question around, but no one knows.
> I do have DMA turned on, etc, yet - on extensive harddrive  
> operations wait
> time is 90+% , which means that machine is waiting, rather than doing
> something meanwhile. (I guess).
> Can someone describe to me , in more detail why is that happening,  
> and what
> steps should I consider to avoid it ? I couldn't find any answers  
> that would
> have help me on net.

I see in your other post that you have a laptop disk drive and, based  
on its specs, it is a 4200RPM one.  Laptop drives are incredibly slow  
for random disk access -- I have one and hate it with passion... even  
though it is slightly better (5400RPM)...

You mention that you are doing expensive disk operations.  If these  
involve a lot of disk seeks (such as, for example, a "cvs update" on  
a large source tree), disk performance will be very very poor and any  
other operation you attempt on it will be slow as well.  These kind  
of drives are the major bottleneck of current laptop machines, in my  
opinion.

(I just wanted to make this clear wrt the hardware.  I do not know if  
Linux is also involved or not.)

-- 
Julio M. Merino Vidal <jmerino@ac.upc.edu>


