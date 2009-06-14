Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbZFNNua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbZFNNua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZFNNuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:50:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46167 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbZFNNuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:50:19 -0400
Date: Sun, 14 Jun 2009 16:50:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, davidel@xmailserver.org,
       mtosatti@redhat.com
Subject: Re: [KVM PATCH v10] kvm: add support for irqfd
Message-ID: <20090614135008.GA12511@redhat.com>
References: <20090520142234.22285.72274.stgit@dev.haskins.net> <20090614092542.GA4833@redhat.com> <4A34EFD9.7010303@novell.com> <20090614131937.GA10646@redhat.com> <4A34F9D8.5040306@redhat.com> <20090614133035.GD10646@redhat.com> <4A34FDBB.9090100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A34FDBB.9090100@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 04:40:11PM +0300, Avi Kivity wrote:
> Michael S. Tsirkin wrote:
>
>  
>
>>> I don't want to assume that the eventfds all come from the same source.
>>>
>>> That said, we have a workaround, allocate a new gsi with the same 
>>> routes  and attach the excess eventfds there.
>>>     
>>
>> Right. So you are ok with 1:1 irqfd:gsi requirement for now?
>> This seems nicer than N:1 with an arbitrary N
>
> Not too happy, but okay.

Is the answer 42:1 then, as usual?

