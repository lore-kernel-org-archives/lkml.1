Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZD1JgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZD1JgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZD1Jf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:35:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60375 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbZD1Jf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:35:56 -0400
Message-ID: <49F6CDFC.6000400@redhat.com>
Date: Tue, 28 Apr 2009 12:35:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com> <49F5B2DA.5060207@novell.com>
In-Reply-To: <49F5B2DA.5060207@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:

  

>> Sure, the interface remains the same (write 8 bytes), but the
>> implementation can change.  For example, we can implement it to work
>> from interrupt context, once we hack the locking appropriately.
>>     
>
> I was thinking more along the lines of eventfd_signal().  AIO and vbus
> currently use this interface, as opposed to the more polymorhpic
> f_ops->write().
>
>   

But eventfd_signal basically marries us to eventfd.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

