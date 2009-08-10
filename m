Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZHJS4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZHJS4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbZHJS4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:56:20 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:45016 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZHJS4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RLijvAfiTcs52qViJQdr2lvFBPNyzC+wVOSpQqpVx0oFJdaXyDorsa9CxuEBP1avy4
         JqpbxudtI8IzlcmfvTVjbXTabWC/cVGQNGFVDWzr0Xm43S6hBgW5+Zbl3me59bE36rJ+
         md67rXIMm6BS1cL5myFGSNmxBMCDrABf4fSn4=
MIME-Version: 1.0
In-Reply-To: <1249925740.2501.9.camel@dhcp231-106.rdu.redhat.com>
References: <1249925740.2501.9.camel@dhcp231-106.rdu.redhat.com>
Date: Mon, 10 Aug 2009 20:56:18 +0200
Message-ID: <19f34abd0908101156x2bc92b22ud1748abb153800fb@mail.gmail.com>
Subject: Re: kmemcheck in linux-next causes NULL pointer dereference at 
	task_rq_lock
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/10 Eric Paris <eparis@redhat.com>:
> I'm using 2.6.31-rc5-next-20090810 on a vmware server.  Originally I saw
> messages about setting to one cpu, so I booted with maxcpu=1.  I get
> this same panic with and without maxpu.  Booting with kmemcheck=0 boots
> just fine.
>
> I have not tested kmemcheck in linus' tree but will start looking for a
> working version now.  Any suggestions or things I should try?

Hi, thanks for the report, and for trying it out.

Does it crash with "kmemcheck=0 maxcpus=1" (it should be maxcpus, not
maxcpu). This should be a simple way of determining whether it was
kmemcheck or the existing maxcpus code, which we use, that broke.

If you can send config (off-list, probably), I will try to reproduce
and investigate more tomorrow.

Thanks,


Vegard
