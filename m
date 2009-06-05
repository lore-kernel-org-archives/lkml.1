Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZFEJSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZFEJSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZFEJSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:18:06 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:44158 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZFEJSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vvn1NtYpJaESXl8uha039zB/vJX7/YB82sIagbSH5L0ZaPk2QJbGhwOPIoqS5wxKx8
         YtUS1JhIKfVxayv1CUz0ISsVTzGAsVs9IxqVUeW6G3DqdXlfpZ4iBZoK8r2sdFcONUTk
         6i9mIKXHB9/KBOKOIwtd9luSnO1pvJRmOOdKo=
Date: Fri, 5 Jun 2009 17:20:14 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090605092014.GA8354@cr0.nay.redhat.com>
References: <4A289928.7040508@oracle.com> <20090605054902.GF7962@cr0.nay.redhat.com> <4A28B63E.1080004@oracle.com> <20090605064316.GB8171@cr0.nay.redhat.com> <4A28C1A4.9050708@oracle.com> <20090605080019.GD8171@cr0.nay.redhat.com> <4A28DECC.8040804@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28DECC.8040804@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 05:01:00PM +0800, Tao Ma wrote:
>>>>>>> I just noticed this when kexec fails in "Can't find kernel 
>>>>>>> text map area  from kcore".
>>>>>>>
>>>>>>> Is there something wrong?
>>>>>> It looks like that error message is from userspace?
>>>>> I just started kdump and get the error message.
>>>> IIRC, kdump should use /proc/vmcore, instead of /proc/kcore...
>>>> nothing related.
>>> in el5, when start kdump service it will do something like
>>> /sbin/kexec --args-linux -p '--command-line=ro root=LABEL=/ rhgb 
>>> quiet  irqpoll maxcpus=1' 
>>> --initrd=/boot/initrd-2.6.18-53.el5kdump.img   
>>> /boot/vmlinuz-2.6.18-53.el5
>>>
>>> And the error message is from there.
>>
>>> From /sbin/kexec? I just checked the source code of kexec-tools,
>> I haven't found that message...
> No, it is there.
> See kexec-tools-1.101-reloc-update.patch.
> src rpm is kexec-tools-1.101-194.4.el5.src.rpm. So it is a patch from el5.

Oh, I used the original source code without any extral patches..

Thanks for your reply.

