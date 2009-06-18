Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZFRJDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZFRJDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZFRJDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:03:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59744 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbZFRJDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:03:32 -0400
Message-ID: <4A3A02F8.6040301@redhat.com>
Date: Thu, 18 Jun 2009 12:03:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [KVM-RFC PATCH 1/2] eventfd: add an explicit srcu based notifier
 interface
References: <20090616022041.23890.90120.stgit@dev.haskins.net> <20090616022956.23890.63776.stgit@dev.haskins.net> <20090616140240.GA9401@redhat.com> <4A37AEF7.7070203@novell.com>
In-Reply-To: <4A37AEF7.7070203@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 05:40 PM, Gregory Haskins wrote:
>
> Something else to consider:  For iosignalfd, we can assume we will
> always be called from vcpu process context so we might not really need
> official affirmation from the system.  For irqfd, we cannot predict who
> may be injecting the interrupt (for instance, it might be a
> PCI-passthrough hard-irq context).  I am not sure if this knowledge
> actually helps to simplify the problem space, but I thought I should
> mention it.
>    

We can't assume anything.  Userspace might hand out that eventfd to anyone.

-- 
error compiling committee.c: too many arguments to function

