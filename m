Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbZD1LIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbZD1LIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932295AbZD1LIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:08:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbZD1LIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:08:34 -0400
Message-ID: <49F6E3B2.5010306@redhat.com>
Date: Tue, 28 Apr 2009 14:08:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, davidel@xmailserver.org
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via	eventfd-notification
 interface
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F572EF.4010909@redhat.com> <49F58A8C.7090808@novell.com> <49F58D75.7040304@redhat.com> <49F5B2DA.5060207@novell.com> <49F6CDFC.6000400@redhat.com> <49F6DB9D.3080501@novell.com> <49F6E1CA.1010106@redhat.com> <49F6E2BB.9070604@novell.com> <49F6E313.7020502@redhat.com>
In-Reply-To: <49F6E313.7020502@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>>
>> So what is your proposal for such interface?
>>
>>   
>
> ->write().
>

Alternatively, a new fileop ->signal_event(), which would map to 
eventfd_signal() or irqfd_signal().  This would be defined to work in 
irq contexts.  It may also be useful for uio interrupts.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

