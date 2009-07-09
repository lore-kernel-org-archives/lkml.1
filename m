Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbZGICbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbZGICbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbZGICbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:31:43 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:45081 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbZGICbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gGjCiTCcMUHzyMXWESMxJvs7QZ6ruZHYphGH3lOF3xZu69PAON/AomGJCSwtkFxGrZ
         J1Mczyqig/o3wTN5Rzjdihbb+k7T1TvBiYebULoCgZMuGYHfqqxd+04F1jG1fCk1ClRr
         CtLuQfRvVzF7fy/PL3Q7JN/yF5XklbSk9e98I=
MIME-Version: 1.0
In-Reply-To: <4A554F1E.5020508@oracle.com>
References: <20090623144221.GA29593@suse.de> <4A54A538.3080407@redhat.com>
	 <20090708140419.GA20418@suse.de> <4A54A938.5030807@redhat.com>
	 <20090708145625.GA20690@suse.de> <4A54B5C2.9000908@redhat.com>
	 <20090708154758.GB20979@suse.de>
	 <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>
	 <b6a2187b0907081743w61102ff4u75d15c2f3cae26d@mail.gmail.com>
	 <4A554F1E.5020508@oracle.com>
Date: Thu, 9 Jul 2009 10:31:41 +0800
Message-ID: <b6a2187b0907081931w7dcf2544m4b580f7841b80cf3@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@suse.de>,
       Peter Jones <pjones@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 9:59 AM, Randy Dunlap<randy.dunlap@oracle.com> wrote:
>> Without CONFIG_EMBEDDED ...
>>   CONFIG_NAMESPACES=y
> Under General Setup, Namespaces support

You're good. Thanks.

>> With CONFIG_EMBEDDED=y ...
>>   # CONFIG_NAMESPACES is not set
>>   CONFIG_VMSPLIT_3G=y
> Under Processor type and features, Memory split

This is one I'm having trouble with. When CONFIG_EMBEDED is not set, I
can't find any "VMSPLIT" in .config, but when CONFIG_EMBEDDED is set,
I'll have to choose the VMSPLIT option. Should I select VMSPLIT_3G?

Here's what it says ...

  | Prompt: Memory split
  |   Defined at arch/x86/Kconfig:1062
  |   Depends on: EXPERIMENTAL && X86_32 && EMBEDDED
  |   Location:
  |     -> Processor type and features
  |   Selected by: EXPERIMENTAL && X86_32 && EMBEDDED && m

Thanks,
Jeff.
