Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYEDXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYEDXQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 19:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYEDXQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 19:16:01 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:44317 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYEDXQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 19:16:00 -0400
Message-ID: <481E4312.9060909@fr.ibm.com>
Date: Mon, 05 May 2008 01:13:22 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Benjamin Thery <benjamin.thery@bull.net>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>, Tejun Heo <htejun@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 00/10] sysfs tagged directories
References: <20080429171015.473938697@theryb.frec.bull.fr> <20080429173621.GA16625@suse.de> <20080429180445.GA18110@sergelap.austin.ibm.com> <20080429184151.GA19794@suse.de> <20080429193417.GA19282@sergelap.austin.ibm.com> <20080501031341.GD4911@suse.de> <20080501151051.GB16038@sergelap.austin.ibm.com> <m11w4lho08.fsf@frodo.ebiederm.org> <20080501210550.GA22534@sergelap.austin.ibm.com> <m1prs5fzzd.fsf@frodo.ebiederm.org> <20080502174222.GA16493@sergelap.austin.ibm.com>
In-Reply-To: <20080502174222.GA16493@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serue@us.ibm.com> writes:
>>
>>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>> Ok as it turns out Benjamin Thery does in fact have a patch to fix this.
>>> Benjamin, please send your renaming patch out tomorrow if you can?
>>>
>>> I guess this is why I didn't really see the problem Benjamin said there
>>> was - it just works with SYSFS_DEPRECATED  :)
>> It will be nice to see that patch.  I'm curious what the problem was.
>>
>> Eric
> 
> Here is the patch he had privately sent.  As the comments indicate he's
> still refining it so yell at me not him...   but this on top of the
> tagged dir patchset makes everything work for me.
> 
> (I'd *really* like to see network namespaces be generally usable sometime
> in 2.6.26.)

Serge,

I posted a fix to Dave Miller which was included in net-2.6 and merged 
in 2.6.26-rc1.

http://marc.info/?l=linux-netdev&m=120959135229360&w=2

This one should fix your problem for sysfs.

There is another fix to do in order to avoid name conflicts with network 
interfaces belonging to different namespaces, eg. allows to rename 
veth1234 to eth0 without conflicting with the network device belonging 
in init_net, I send this patch to container@ first to have it merged 
with the sysfs patchset.

Thanks,

   -- Daniel
