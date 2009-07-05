Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZGEKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZGEKkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 06:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZGEKkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 06:40:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40180 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbZGEKkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 06:40:45 -0400
Message-ID: <4A5083B3.7010307@redhat.com>
Date: Sun, 05 Jul 2009 13:42:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v9 0/5] irqfd fixes and enhancements
References: <20090702153454.20186.99191.stgit@dev.haskins.net> <4A4CD729.6050300@redhat.com> <4A50723E.6030305@redhat.com> <20090705103857.GA3923@redhat.com>
In-Reply-To: <20090705103857.GA3923@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2009 01:38 PM, Michael S. Tsirkin wrote:
>> ... and unapplied.  There's a refcounting mismatch in irqfd_cleanup: a
>> reference is taken for each irqfd, but dropped for each guest.  This
>> causes an oops if a guest with no irqfds is created and destroyed:
>>      
>
> Avi, I verified and it seems that reverting just the last patch
> in series should be enough. Comments?
>    

I'll reapply the first N-1 patches.

-- 
error compiling committee.c: too many arguments to function

