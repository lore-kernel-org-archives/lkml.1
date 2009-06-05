Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZFEGlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZFEGlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZFEGlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:41:05 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:39637 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZFEGlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ATQrI/1jGDNPqnKXrOtfSC86k0qihUoji1/gBTbvYMFMHmYQXBucScds/5nqW4lz+Z
         cxQNsFM9vtHpniSzEvI/GgsYq/k2E2UEr7v/sIuZWT1xg4oiJEwg199HEi/vyoBwnp3i
         bc+LVT63AJXtmnqjc4o2x4r6mhSwEb60LXR0o=
Date: Fri, 5 Jun 2009 14:43:16 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090605064316.GB8171@cr0.nay.redhat.com>
References: <4A289928.7040508@oracle.com> <20090605054902.GF7962@cr0.nay.redhat.com> <4A28B63E.1080004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28B63E.1080004@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 02:07:58PM +0800, Tao Ma wrote:
>
>
> Amerigo Wang wrote:
>> On Fri, Jun 05, 2009 at 12:03:52PM +0800, Tao Ma wrote:
>>> Hi list,
>>>       In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable 
>>> large  to be 281474974617600.
>>> While in a x86 box, it is 931131392 which looks sane.
>>>
>>> [root@test8 ~]# ll /proc/kcore
>>> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
>>>
>>> [root@ocfs2-test9 ~]$ ll /proc/kcore
>>> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore
>>
>> Hmm, what is your physical RAM size on test8?
>> /proc/kcore looks fine on my x86_64 box.
> Only 4G.

Hmm, my x86_box has 8G mem, the size of kcore looks much
saner than the above huge number, but it is still wrong
according to what the man page describes...

Please do what Andrew said, it will be helpful.

>>
>>> I just noticed this when kexec fails in "Can't find kernel text map 
>>> area  from kcore".
>>>
>>> Is there something wrong?
>>
>> It looks like that error message is from userspace?
> I just started kdump and get the error message.

IIRC, kdump should use /proc/vmcore, instead of /proc/kcore...
nothing related.

Thanks.
