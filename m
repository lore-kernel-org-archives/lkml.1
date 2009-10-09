Return-Path: <linux-kernel-owner+w=401wt.eu-S1761167AbZJIQyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761167AbZJIQyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761125AbZJIQx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:53:59 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:34137 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZJIQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:53:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:x-archive:mime-version:content-type;
        b=qC1q9DhajOYNjpmF8x1Zh6xlxbY5S94qm20ZWobnhSkPVdM5xX3GOU8d2L19eROhQP
         RL4vcvJR1gWc7qLrvg1WXfUqKUg1aFMUnv1xDTUzixBOqA5l7osZaMhzdFwRScliCKCg
         RbRTcBGWiNl+uijOYntwVOhnqVNwuzOCBs12g=
Date: Fri, 9 Oct 2009 13:53:14 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31: no login prompt
In-Reply-To: <20091009160951.GA2766@kroah.com>
Message-ID: <alpine.LNX.2.01.0910091349490.5219@dyndns.pervalidus.net>
References: <alpine.LNX.2.01.0909191941270.24796@pervalidus> <20091009160951.GA2766@kroah.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1215901895-1255107199=:5219"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1215901895-1255107199=:5219
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Fri, 9 Oct 2009, Greg KH wrote:

> On Sat, Sep 19, 2009 at 07:43:04PM -0300, Frédéric L. W. Meunier wrote:
>> While booting 2.6.31, I don't get a login prompt after runlevel
>> 3:
>>
>> Sep 19 18:31:25 pervalidus init: Id "c1" respawning too fast: disabled for 5 minutes
>> Sep 19 18:31:25 pervalidus init: Id "c3" respawning too fast: disabled for 5 minutes
>> Sep 19 18:31:25 pervalidus init: Id "c2" respawning too fast: disabled for 5 minutes
>>
>> It works fine with 2.6.30.5.
>>
>> What can be causing it ?
>
> This should be fixed in 2.6.31.3, can you verify this?

Greg, this was caused by using vc/* entries in /etc/inittab and 
old devfs rules in udev.

I don't think the fix would make any difference for it. Would it 
?
--8323328-1215901895-1255107199=:5219--
