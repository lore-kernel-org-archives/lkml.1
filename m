Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZIVPu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZIVPu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbZIVPu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:50:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZIVPu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:50:58 -0400
Message-ID: <4AB8F256.2080205@redhat.com>
Date: Tue, 22 Sep 2009 18:50:46 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
References: <4AB3CDEC.5050902@zytor.com> <1253342422-13811-1-git-send-email-avi@redhat.com> <4AB8980D.5070803@redhat.com> <20090922143223.GA31702@elte.hu> <4AB8E2F1.6030401@redhat.com>
In-Reply-To: <4AB8E2F1.6030401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 05:45 PM, Avi Kivity wrote:
>> Would be nice to convert some existing open-coded return-to-user-space
>> logic to this facility. One such candidate would be lockdep_sys_exit?
>
> I only implemented this for x86, while lockdep is arch independent.  
> If arch support is added, it should be trivial.
>

The lockdep_sys_exit bit is actually x86/s390 only, and can easily be 
adapted to use the new functionality on x86 only.  I'll try it out.

-- 
error compiling committee.c: too many arguments to function

