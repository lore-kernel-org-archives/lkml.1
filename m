Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321Ab0ATMCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0ATMCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584Ab0ATMCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:02:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0ATMCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:02:18 -0500
Date: Wed, 20 Jan 2010 13:59:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Gleb Natapov <gleb@redhat.com>,
       Julia Lawall <julia@diku.dk>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: only allow one gsi per fd
Message-ID: <20100120115911.GA9761@redhat.com>
References: <20100113165809.GA13334@redhat.com> <4B53052D.3020905@redhat.com> <20100120113641.GB9610@redhat.com> <4B56EE60.4030009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B56EE60.4030009@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 01:52:00PM +0200, Avi Kivity wrote:
> On 01/20/2010 01:36 PM, Michael S. Tsirkin wrote:
>> On Sun, Jan 17, 2010 at 02:40:13PM +0200, Avi Kivity wrote:
>>    
>>> On 01/13/2010 06:58 PM, Michael S. Tsirkin wrote:
>>>      
>>>> Looks like repeatedly binding same fd to multiple gsi's with irqfd can
>>>> use up a ton of kernel memory for irqfd structures.
>>>>
>>>> A simple fix is to allow each fd to only trigger one gsi: triggering a
>>>> srorm of interrupts in guest is likely useless anyway, and we can do it
>>>> by binding a single gsi to many interrupts if we really want to.
>>>>
>>>>        
>>> Applied and queued, thanks.
>>>      
>> I'm guessing we need this for 2.6.32 stable and 2.6.33 as well?
>>    
>
> That's what 'queued' means.

Aha. Which git branch is used for these?

> -- 
> error compiling committee.c: too many arguments to function
