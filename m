Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab0BRWDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:03:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:59483 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab0BRWDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:03:15 -0500
Message-ID: <4B7DB912.70806@windriver.com>
Date: Thu, 18 Feb 2010 16:02:58 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Biederman <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 7/8] ehci-dbgp: split PID register updates for IN and
 OUT pipes
References: <1266014369-29547-1-git-send-email-jason.wessel@windriver.com> <1266014369-29547-8-git-send-email-jason.wessel@windriver.com> <20100218000103.GI12197@kroah.com>
In-Reply-To: <20100218000103.GI12197@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2010 22:02:52.0634 (UTC) FILETIME=[1E08CBA0:01CAB0E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Feb 12, 2010 at 04:39:28PM -0600, Jason Wessel wrote:
>   
>> This patch addresses two problems:
>>     
>
> Do you want me to take this patch, and 8/8 in my tree, or yours?
>
> If yours, please add a:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to the patch.
>
>   


I added the Ack's.

I will keep the patches in my tree because unless the
kernel-parameters.txt patch is split it will not apply cleanly for patch
8/8.  It currently depends on the kdb tree, even though the source code
portions do not depend on anything.  If the early debug patch set is
rejected for some reason, I'll fix patch 8/8 and submit it to your tree.

You might consider patch 7/8 for -stable because I observed the dbgp
device no longer dropping any characters when there is a significant
printk volume in a short period of time.

Thanks,
Jason.
