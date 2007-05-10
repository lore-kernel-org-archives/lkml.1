Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXEJPN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXEJPN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXEJPNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:13:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:11345 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbXEJPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AJjPJr8nipqDVv73i+0ZG8AfHGoqL8pYTlqnk5lCR3m3IVJJUb6b/rzKqKjy6Xvtq4mpeQT8tYdt+WFDEObDyGDQN2RQeEfgIKl0Ym7wKUJjS4ZBaxvtoRUg3+4Aql5xL4Is7Jgmaurqe2Am5ipykWGhSSYLmLncDXaBJ71epXw=
Message-ID: <46433686.6080007@gmail.com>
Date: Thu, 10 May 2007 17:13:10 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Rankin <rankincj@yahoo.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] driver-core: don't free devt_attr till the device is
 released
References: <602729.80444.qm@web52910.mail.re2.yahoo.com> <4641CD01.6010309@gmail.com> <20070509145747.GA27259@kroah.com> <4641E245.7040603@gmail.com> <20070509154039.GA27681@kroah.com> <46432FFD.1040304@gmail.com> <20070510150501.GA22752@kroah.com>
In-Reply-To: <20070510150501.GA22752@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> Applies well to 2.6.20 and 21.  As sysfs-immediate-disconnect doesn't
>> seem to be included in 2.6.22, this should be included in linus#master
>> too (applies well there as well).
> 
> As I don't think we should be adding your sysfs rework to 2.6.22 just
> yet, any objections to me just sending this to Linus for 2.6.22 and
> waiting on your previous one for when the whole sysfs rework patchset is
> sent?

No objection at all.  That actually is exactly my intention.  The
make-attrs-static patch will conflict with this fix tho.  Just let me
know when it breaks, I'll post updated one.

Thanks.

-- 
tejun
