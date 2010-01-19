Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030Ab0ASOzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0ASOzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:55:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079Ab0ASOzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:55:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab0ASOzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:55:05 -0500
Date: Tue, 19 Jan 2010 16:52:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com
Cc: Davide Libenzi <davidel@xmailserver.org>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
Message-ID: <20100119145202.GC28465@redhat.com>
References: <20100113171222.GA19798@redhat.com> <4B5305CA.5070001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5305CA.5070001@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 02:42:50PM +0200, Avi Kivity wrote:
> On 01/13/2010 07:12 PM, Michael S. Tsirkin wrote:
>> Deassigning irqfd and assigning back caused spurious interrupt. fix this
>> by clearing the counter on deassign.  This is on top of davidel's patch
>> which makes clearing eventfd counter from modules possible.
>>    
>
> Applied both, thanks.

Hmm, I see this in kvm master.  Avi/Marcelo, since this is a bugfix, can
you queue this patchset for 2.6.33 and 2.6.32 stable as well please?

> -- 
> error compiling committee.c: too many arguments to function
