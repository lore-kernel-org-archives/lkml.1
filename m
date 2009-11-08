Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZKHNBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZKHNBQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZKHNBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:01:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbZKHNBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:01:15 -0500
Message-ID: <4AF6C112.4010601@redhat.com>
Date: Sun, 08 Nov 2009 15:01:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 02/11] Add "handle page fault" PV helper.
References: <1257076590-29559-1-git-send-email-gleb@redhat.com> <1257076590-29559-3-git-send-email-gleb@redhat.com> <20091102092214.GB8933@elte.hu> <20091102160410.GF27911@redhat.com> <20091102161248.GB15423@elte.hu> <20091102162234.GH27911@redhat.com> <20091102162941.GC14544@elte.hu> <20091102174208.GJ27911@redhat.com> <20091108113654.GO11372@elte.hu> <4AF6BCE5.3030701@redhat.com> <20091108125135.GA13099@elte.hu>
In-Reply-To: <20091108125135.GA13099@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2009 02:51 PM, Ingo Molnar wrote:
>> Maybe we should generalize paravirt-ops patching in case if (x) f() is
>> deemed too expensive.
>>      
> Yes, that's a nice idea. We have quite a number of 'conditional
> callbacks' in various critical paths that could be made lighter via such
> a technique.
>
> It would also free new callbacks from the 'it increases overhead even if
> unused' criticism and made it easier to add them.
>    

We can take the "immediate values" infrastructure as a first step.  Has 
that been merged?

-- 
error compiling committee.c: too many arguments to function

