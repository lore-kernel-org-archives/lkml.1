Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZHIHnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZHIHnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 03:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZHIHnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 03:43:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZHIHnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 03:43:00 -0400
Message-ID: <4A7E7F52.7020100@redhat.com>
Date: Sun, 09 Aug 2009 10:48:34 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Arnd Bergmann <arnd@arndb.de>, alacrityvm-devel@lists.sourceforge.net,
       "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/7] AlacrityVM guest drivers Reply-To:
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <4A7AE150.7040009@redhat.com> <4A7AAB1A0200005A00051BED@sinclair.provo.novell.com> <200908061740.04276.arnd@arndb.de> <4A7AFBE3.5080200@redhat.com> <4A7AD2D20200005A00051C83@sinclair.provo.novell.com>
In-Reply-To: <4A7AD2D20200005A00051C83@sinclair.provo.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 07:55 PM, Gregory Haskins wrote:
> Based on this, I will continue my efforts surrounding to use of vbus including its use to accelerate KVM for AlacrityVM.  If I can find a way to do this in such a way that KVM upstream finds acceptable, I would be very happy and will work towards whatever that compromise might be.   OTOH, if the KVM community is set against the concept of a generalized/shared backend, and thus wants to use some other approach that does not involve vbus, that is fine too.  Choice is one of the great assets of open source, eh?   :)
>    

KVM upstream (me) doesn't have much say regarding vbus.  I am not a 
networking expert and I'm not the virtio or networking stack maintainer, 
so I'm not qualified to accept or reject the code.  What I am able to do 
is make sure that kvm can efficiently work with any driver/device stack; 
this is why ioeventfd/irqfd were merged.

I still think vbus is a duplication of effort; I understand vbus has 
larger scope than virtio, but I still think these problems could have 
been solved within the existing virtio stack.

-- 
error compiling committee.c: too many arguments to function

