Return-Path: <linux-kernel-owner+w=401wt.eu-S1758535AbYABLOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535AbYABLOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYABLOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:14:01 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:22916 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYABLOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:14:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VOtySHkWjE12bMIv/4cUrfRvyT5YvTjT5rZ7Xej8kKvBxk/x1PMw3zo6tDLLNdQfEd0XxXVSCqcqBlWLpKZKeyPyfAmf+30mNIx7ttj/qdoEfbXaarbPEyWFOXPbGyO6RDzVztKKigCOAzCluwzIHw6hZz6ztOTPCI6fis+8y74=
Message-ID: <477B71F0.8020706@gmail.com>
Date: Wed, 02 Jan 2008 20:13:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, notting@redhat.com,
       rusty@rustcorp.com.au, kay.sievers@vrfy.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] depmod: sort output according to modules.order, take
 #2
References: <475936CE.70703@gmail.com> <4759379D.8090201@gmail.com> <475BB5AE.40503@gmail.com>
In-Reply-To: <475BB5AE.40503@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Tejun Heo wrote:
>> Kbuild now generates and installs modules.order along with modules.
>> This patch updates depmod such that it sorts module list according to
>> the file before generating output files.  Modules which aren't on
>> modules.order are put after modules which are ordered by
>> modules.order.
>>
>> This makes modprobe to prioritize modules according to kernel
>> Makefile's just as built-in modules are link-ordered by them.
>>
>> This patch is against module-init-tools 3.3-pre1.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: Bill Nottingham <notting@redhat.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: Kay Sievers <kay.sievers@vrfy.org>
> 
> The kernel part is in now.  Rusty Russell, what do you think about this
> depmod change?

Ping?

-- 
tejun
