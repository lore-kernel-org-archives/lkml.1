Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984Ab0AMQBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0AMQBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967Ab0AMQBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:01:48 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:49824 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab0AMQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:01:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kVMCpWiiKKa4z2JHiVYq4+CtYWTkENBI4PJ0EMTCZSskGQoVNbyy/KKX+B4SdmAVwx
         DCw74yQdcQAEnut0l8pIc/89eEV5vB/3mOETNOJL4VgpNTHpZpDNLN7XoGH5/I09MRR4
         58ejmT3tZBU1QqJYgMuA120CAdbjT0zNKkeQI=
Date: Thu, 14 Jan 2010 00:03:41 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Gong Cheng <chengg11@yahoo.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Athan <linux_kernel_aathan@memeplex.com>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Futex hang/lockup problem in 2.6.30+ on AMD64
Message-ID: <20100113160341.GB2902@hack>
References: <4B4C3E4F.9060001@memeplex.com> <20100112145213.GB3925@hack> <1263308127.4244.142.camel@laptop> <2375c9f91001120700r4c2e1e05l5e5be3ddc6a13da2@mail.gmail.com> <556048.68282.qm@web82105.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556048.68282.qm@web82105.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:53:01AM -0800, Gong Cheng wrote:
>Hi guys,
>    It has been a little while when we were hit by the problem, and from then I didn't touch that area, so forgive me if I can not answer all your questions.
>    Basically after switching from 2.6.31.1 and 2.6.31.4, the problem seems to have gone away. 
>    It was very reproducible for us in 2.6.31.1 (if coupled with glibc 2.5.34.1 or any version around. I believe as long as it was after the private futex work in glibc).  
>After the switch, we might have had another similar occurrence but it was not clear if was the same problem. Since it didn't occur again, we let it go. 
>   now we are in 2.6.32.1, and it is still running fine. So the problem is either completely gone with the newer kernels. Or it is just much less likely to happen.
>That is pretty much all I can provide, and hope it helps.
>

Ok, thanks for your confirm.

-- 
Live like a child, think like the god.
 
