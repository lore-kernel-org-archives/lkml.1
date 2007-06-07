Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXFGRC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXFGRC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXFGRCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:02:17 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:46222 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbXFGRCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=l6qEEXZX3ZixxfPXTSrJk9xvMsCu/Pz5SOssMssvKGkTdhs/SqBNvzCO2S2fAnZcDaEjVitUqWwVEaVv8HZrrZLZpJ6SL3SOSwbkOQlCAE8Tfj8x8QRSCsBkt30deg5T+I743Ye7jsNtDQOtvpAfLZFxOJ2kja4FZgCXPI3JpTQ=
Message-ID: <46683A1F.8070208@gmail.com>
Date: Thu, 07 Jun 2007 19:02:23 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <200706061421.l56ELDfB004305@harpo.it.uu.se> <4666D3F8.4010002@gmail.com> <20070606105650.bebf1c95.akpm@linux-foundation.org> <4666FBE8.3030103@gmail.com> <4667A93A.4060608@gmail.com> <4667AD3F.1010405@gmail.com> <4667AF20.4020209@gmail.com> <4667B095.5050508@gmail.com> <4667B241.801@gmail.com> <46682A25.5070409@gmail.com> <20070607160107.GA17800@kroah.com>
In-Reply-To: <20070607160107.GA17800@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It'Greg KH napsal(a):
> On Thu, Jun 07, 2007 at 05:54:13PM +0200, Jiri Slaby wrote:
>> Tejun Heo napsal(a):
>>> Jiri Slaby wrote:
>>>> Tejun Heo napsal(a):
>>>>> Jiri Slaby wrote:
>>>>>> Yes. Now I'm compiling -rc4-mm2.
>>>>> It's probably caused by new sysfs slimdown patches and I'm pretty sure
>>>>> -rc4-mm2 would fail the same way.  The offending one should be one of
>>>>> the following patches.
>>>> There's reverted gregkh-driver-block-device in -mm2. So I wanted to give it a
>>>> try. Do you think it's pointless and that patch has no impact on the behaviour?
>>> I'm not familiar with how lvm vgscan works and the patch does look like
>>> it can affect that.  Please give a shot at -mm2.
>> Yup, it works without any further patches. So it seems like
>> gregkh-driver-block-device is the culprit?
> 
> Culprit for what kind of symptom?  Is CONFIG_SYSFS_DEPRECATED enabled?
> If not, can you try that?

LVM (lvm whatever) writes can't initialize lock 1 and quits.

SYSFS_DEPRECATED solves the issue (-rc4-mm2 minus the revert + SYSFS_DEPRECATED).

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

