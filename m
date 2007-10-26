Return-Path: <linux-kernel-owner+w=401wt.eu-S1764508AbXJZRSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764508AbXJZRSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbXJZRR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:17:56 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:36728 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbXJZRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:17:55 -0400
Message-ID: <47222124.2020802@linux.vnet.ibm.com>
Date: Fri, 26 Oct 2007 22:47:24 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       alsa-devel@alsa-project.org, Amit Shah <amitshah@gmx.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
 - with ALSA
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com> <20071026091722.GA21274@linux.vnet.ibm.com> <20071026155202.GD23016@kroah.com> <s5hzly6nen8.wl%tiwai@suse.de> <3ae72650710260917t3ed93450gd5aa97d1337273f0@mail.gmail.com>
In-Reply-To: <3ae72650710260917t3ed93450gd5aa97d1337273f0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On 10/26/07, Takashi Iwai <tiwai@suse.de> wrote:
>> At Fri, 26 Oct 2007 08:52:02 -0700,
>> Greg KH wrote:
>>> On Fri, Oct 26, 2007 at 02:47:22PM +0530, Kamalesh Babulal wrote:
>>>> I get similar warning, while loading the alsa driver
>>> This is a different problem, not a rename issue like the network one
>>> was.
>>>
>>>> [  191.933548] Advanced Linux Sound Architecture Driver Version 1.0.15
>>>> (Tue Oct 23 06:09:18 2007 UTC).
>>>> [  191.996323] ALSA sound/core/seq/oss/seq_oss.c:232: can't register
>>>> device seq
>>>> [  192.046004] sysfs: duplicate filename 'audio' can not be created
>>>> [  192.086048] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>>> This is an error in the alsa core, perhaps the alsa developers can help
>>> figure out why they are registering the same file twice?
>> ALSA core shouldn't do so.  Maybe a built-in OSS driver conflict with
>> ALSA?  We'd need to check .config, then.
> 
> Maybe:
>    find /sys/ -name audio
> shows the devpath of the already existing device?
> 
> Kay
Hi Kay,

Sorry, I can not work on that machine, till monday, and send the output
of the find by monday morning.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
