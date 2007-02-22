Return-Path: <linux-kernel-owner+w=401wt.eu-S1751416AbXBVFoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbXBVFoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbXBVFoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:44:21 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58094 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXBVFoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:44:21 -0500
Message-ID: <45DD2DC5.2020108@drzeus.cx>
Date: Thu, 22 Feb 2007 06:44:37 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Block layer still stack abuser?
References: <45D59C3C.4090403@drzeus.cx> <17885.1120.437885.35438@notabene.brown>
In-Reply-To: <17885.1120.437885.35438@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Friday February 16, drzeus-list@drzeus.cx wrote:
>   
>> I was wondering if the block layer has been changed into a more serialized
>> manner yet? I've been trying to google this, but so far no luck. I know there
>> was some talk about removing the stack based approach, but I can't find any
>> information about where this went.
>>
>> If it is currently fixed, a pointer to from which version would be nice.
>>     
>
> Might this:
>    http://lkml.org/lkml/2007/2/10/22
>
> relate to your question?
> If you are talking about stacking block device (via dm or md), then a
> patch to fix this in in -mm but there are or were some potential
> issues in dm that seem to be holding it up.
>
>   

Yes, I am. I know there has been general work to reduce stack usage here
and there, but the final suggested solution was to serialize all the
block subsystems so that only one was present on the stack at any given
time.

I was constantly hitting this problem a few years ago when I was running
md+xfs+nfs. The fix was in -mm back then as well. ;)

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

