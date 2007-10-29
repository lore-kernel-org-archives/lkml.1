Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbXJ2Fqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbXJ2Fqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 01:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXJ2Fqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 01:46:40 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:35115 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXJ2Fqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 01:46:39 -0400
Message-ID: <47257387.6010305@linux.vnet.ibm.com>
Date: Mon, 29 Oct 2007 11:15:43 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Tobin Davis <tdavis@dsl-only.net>
CC: Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>,
       alsa-devel@alsa-project.org, Amit Shah <amitshah@gmx.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] sysfs: WARNING: at fs/sysfs/dir.c:424	sysfs_add_one()
 - with	ALSA
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com> <20071026091722.GA21274@linux.vnet.ibm.com> <20071026155202.GD23016@kroah.com> <s5hzly6nen8.wl%tiwai@suse.de> <472220BA.3060201@linux.vnet.ibm.com> <1193498376.32561.219.camel@razman.gruemaster.com>
In-Reply-To: <1193498376.32561.219.camel@razman.gruemaster.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobin Davis wrote:
> First think I noticed, why are you compiling all the drivers into the
> kernel instead of as modules?  Do you need every sound device supported
> simultaneously?
> 
> Tobin
> 
> On Fri, 2007-10-26 at 22:45 +0530, Kamalesh Babulal wrote:
>> Takashi Iwai wrote:
>> > At Fri, 26 Oct 2007 08:52:02 -0700,
>> > Greg KH wrote:
>> >> On Fri, Oct 26, 2007 at 02:47:22PM +0530, Kamalesh Babulal wrote:
>> >>> I get similar warning, while loading the alsa driver
>> >> This is a different problem, not a rename issue like the network one
>> >> was.
>> >>
>> >>> [  191.933548] Advanced Linux Sound Architecture Driver Version 1.0.15
>> >>> (Tue Oct 23 06:09:18 2007 UTC).
>> >>> [  191.996323] ALSA sound/core/seq/oss/seq_oss.c:232: can't register
>> >>> device seq
>> >>> [  192.046004] sysfs: duplicate filename 'audio' can not be created
>> >>> [  192.086048] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
>> >> This is an error in the alsa core, perhaps the alsa developers can help
>> >> figure out why they are registering the same file twice?
>> > 
>> > ALSA core shouldn't do so.  Maybe a built-in OSS driver conflict with
>> > ALSA?  We'd need to check .config, then.
>> > 
>> > 
>> > Takashi
>> > -
>> Hi Takashi,
>>
>> Attaching the .config file,
>>
Hi Tobin,

I Tried compiling the kernel with allyesconfig and with mtd devices disabled.
When i tried booting into the kernel, i get this warning.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
