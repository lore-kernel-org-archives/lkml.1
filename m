Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXDRH46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXDRH46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXDRH46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:56:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:55042 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbXDRH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:56:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JmgwnyXOkVb5+0jkvDt9t8G9EDnrdX5qDhk7dfrJ//dHaxyJzsC59pP1EYBtmOyspaVOp0kSUYNGnif9j+4qrgqtg0fr7/qwzmCY7VuEDH8+pL0FuZHPqhTdJ6bGQgbyobAcnhJNkHUnAtNnni1fqJrDazhpJG0FVnALE1q1UP8=
Message-ID: <4625CF43.5010704@gmail.com>
Date: Wed, 18 Apr 2007 16:56:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add Samsung HD401LJ to the NCQ blacklist
References: <20070418061541.GA11293@roonstrasse.net> <4625BA1A.9030808@gmail.com> <20070418074859.GA21494@roonstrasse.net>
In-Reply-To: <20070418074859.GA21494@roonstrasse.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann wrote:
> On 2007/04/18 08:26, Tejun Heo <htejun@gmail.com> wrote:
>> Can you try it on another controller?  Say, a ahci or sil24?
> 
> Seems to work ok on a Via VT8251 controller (AHCI) on kernel
> 2.6.21-rc6-git4 without my NCQ disabling patch.

Unfortunately, NCQ is not supported on VT8251, so it doesn't prove
anything.  :-(

> By the way, on this machine, I had a lot of SATA timeouts during
> kernel boot, which were solved by appending "nomsi".  Do you believe
> there might be a relation to the NCQ problems on my first (Nforce)
> machine?

It's more likely your chipset just has busted MSI support.  Please post
the result of 'lspci -tv' and 'lspci -nn'.

Thanks.

-- 
tejun
