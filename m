Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYLJJRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYLJJRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 04:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbYLJJQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 04:16:50 -0500
Received: from gecko.sbs.de ([194.138.37.40]:24523 "EHLO gecko.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYLJJQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 04:16:49 -0500
Message-ID: <493F88E3.1010201@siemens.com>
Date: Wed, 10 Dec 2008 10:16:19 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/45] KVM: x86: Support for user space injected NMIs
References: <1228736216-15787-1-git-send-email-avi@redhat.com> <1228736216-15787-13-git-send-email-avi@redhat.com> <493D0E0A.2000400@siemens.com> <493F81E9.90306@redhat.com>
In-Reply-To: <493F81E9.90306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jan Kiszka wrote:
>> Avi Kivity wrote:
>>  
>>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>>
>>> Introduces the KVM_NMI IOCTL to the generic x86 part of KVM for
>>> injecting NMIs from user space and also extends the statistic report
>>> accordingly.
>>>     
>> Avi, please consider [1] again. You've already merged the related user
>> space cleanup, and I was just waiting for your comment on how to deal
>> with the kernel part, ideally _before_ merging the superfluous
>> ready_for/request NMI interface into mainline.
>>
>> Thanks,
>> Jan
>>
>> [1] http://permalink.gmane.org/gmane.comp.emulators.kvm.devel/25016
>>
>>   
> 
> Do you mean, drop these nmi window bits completely from 2.6.29, keeping
> just injection?  We can do that without breaking released userspace by
> dropping KVM_CAP_NMI and adding KVM_CAP_NMI2 (better name?) that doesn't
> have interrupt window support.

KVM_CAP_USER_NMI

> 
> This means that userspace versions that supported KVM_CAP_NMI will not
> work with 2.6.29, but I think we can live with that.
> 
> If this is acceptable, please send a patch that converts KVM_CAP_NMI to
> KVM_CAP_NMI2, and a corresponding patch for userspace.  I will fold the
> kernel patch into the 2.6.29 submission, and apply both patches to the
> master branch.

OK, sounds reasonable. I will work out such patches.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 26
Corporate Competence Center Embedded Linux
