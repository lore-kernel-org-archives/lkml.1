Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0BEQB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:01:28 -0500
Received: from mail-fx0-f211.google.com ([209.85.220.211]:44611 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab0BEQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:01:26 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Feb 2010 11:01:26 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=YfmhepiIdvElN7Y7HhbZlWyBj5Grnby3yzfFVP7Sl6aTitPrucOkVjOPz1CBCwxGyJ
         UyLnYQzU7tNT7zdGOA/Hz7k0hd0OV3Cj0SIANeYg+HNHefbFzV3PkUoj0KkroXR2SbJc
         HqabgqYKPNjxsA9gz4gwAzwAtqxLwssa+cdFQ=
Date: Fri, 5 Feb 2010 23:57:01 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.32.8-stable review : kernel crashed asap
Message-ID: <20100205155701.GC9690@hack>
References: <201002042129.41462.toralf.foerster@gmx.de> <20100205151021.GB9690@hack> <201002051622.02980.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201002051622.02980.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 04:22:02PM +0100, Toralf Förster wrote:
>
>Américo Wang wrote at 16:10:21
>> On Thu, Feb 04, 2010 at 09:29:41PM +0100, Toralf Förster wrote:
>> >Immediately during boot it crashed w/ the attached config - no lines
>> > within syslog  to post.
>> 
>> What error messages did you see on your screen?
>> 
>
>I attached a screen shot.
>

Thanks! It's better that if you can capture these info via netconsole
or something like that, so that you copy and paste them into email.

Hmm, it seems that a null pointer deref happened in
net/ipv4/devinet.c::inetdev_init(), so Cc'ing netdev guys....

Could you please run the command:

  addr2line -e your_2.6.32.8_vmlinux 0xc11fea28

to check in which line we dereferenced a null pointer?

Thank you!

-- 
Live like a child, think like the god.
 
