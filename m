Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbZFNNkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbZFNNkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZFNNkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:40:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712AbZFNNkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:40:11 -0400
Message-ID: <4A34FDBB.9090100@redhat.com>
Date: Sun, 14 Jun 2009 16:40:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090614092542.GA4833@redhat.com> <4A34EFD9.7010303@novell.com> <20090614131937.GA10646@redhat.com> <4A34F9D8.5040306@redhat.com> <20090614133035.GD10646@redhat.com>
In-Reply-To: <20090614133035.GD10646@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:

  

>> I don't want to assume that the eventfds all come from the same source.
>>
>> That said, we have a workaround, allocate a new gsi with the same routes  
>> and attach the excess eventfds there.
>>     
>
> Right. So you are ok with 1:1 irqfd:gsi requirement for now?
> This seems nicer than N:1 with an arbitrary N

Not too happy, but okay.

-- 
error compiling committee.c: too many arguments to function

