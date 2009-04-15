Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZDOMte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZDOMte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 08:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759866AbZDOMtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 08:49:09 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:59275 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523AbZDOMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 08:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JyV3NZ3kr2xnvjKo2Kis+NuQ14ALsOWw+4ECA0uLg/WnbGUPKajF1BCc2uASJx5wK/
         mJ4bAX3kZX7zddVFezgWpTKIoPPUokqtnWlE4/SmiWQ35yIEpRAwihBzlFoRvM5wyCrG
         vLTsiUV9pcfHU1OFuH1oMehhwrjygzNuX7Skk=
MIME-Version: 1.0
In-Reply-To: <20090409144611.GH7372@bombadil.infradead.org>
References: <a4423d670904080603w50face2fl87cd16bd7967cb5d@mail.gmail.com>
	 <20090408220921.GF7372@bombadil.infradead.org>
	 <a4423d670904090146w2937bf15le2afb5dfad718f0e@mail.gmail.com>
	 <20090409144611.GH7372@bombadil.infradead.org>
Date: Wed, 15 Apr 2009 16:49:03 +0400
Message-ID: <a4423d670904150549s48b844a7iba097acaf875b992@mail.gmail.com>
Subject: Re: 2.6.30-rc1: parisc: system hangs on boot at __schedule()
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: linux-parisc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/9 Kyle McMartin <kyle@mcmartin.ca>:
> On Thu, Apr 09, 2009 at 12:46:15PM +0400, Alexander Beregalov wrote:
>> 2009/4/9 Kyle McMartin <kyle@mcmartin.ca>:
>> > On Wed, Apr 08, 2009 at 05:03:04PM +0400, Alexander Beregalov wrote:
>> >> Hi
>> >>
>> >> Machine is HP j6000.
>> >> CPU(s): 2 x PA8700 (PCX-W2) at 750.000000 MHz
>> >>
>> >> gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5)
>> >>
>> >>
>> >> Machine hangs before starting rc scripts, but SysRq and C-A-Del work.
>> >>
>> >> All tasks are at __schedule+0x268/0x7bc:
>> >>
>> >
>> > .config?
>>
>> Sorry, attached.
>
> Thanks, I swapped disks into my j6700 and will try to reproduce.

It seems the problem is the same as mentioned here:
http://marc.info/?l=linux-kernel&m=123920746830420&w=2

The patch  fixes the issue.

James?
The same problem on two of my hosts: x86_64 with LSI SAS MegaRAID
and parisc with SYM53C8XX_2
