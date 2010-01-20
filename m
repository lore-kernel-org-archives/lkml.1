Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438Ab0ATLwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0ATLwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 06:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118Ab0ATLwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 06:52:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab0ATLwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 06:52:08 -0500
Message-ID: <4B56EE60.4030009@redhat.com>
Date: Wed, 20 Jan 2010 13:52:00 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Gleb Natapov <gleb@redhat.com>,
       Julia Lawall <julia@diku.dk>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: only allow one gsi per fd
References: <20100113165809.GA13334@redhat.com> <4B53052D.3020905@redhat.com> <20100120113641.GB9610@redhat.com>
In-Reply-To: <20100120113641.GB9610@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 01:36 PM, Michael S. Tsirkin wrote:
> On Sun, Jan 17, 2010 at 02:40:13PM +0200, Avi Kivity wrote:
>    
>> On 01/13/2010 06:58 PM, Michael S. Tsirkin wrote:
>>      
>>> Looks like repeatedly binding same fd to multiple gsi's with irqfd can
>>> use up a ton of kernel memory for irqfd structures.
>>>
>>> A simple fix is to allow each fd to only trigger one gsi: triggering a
>>> srorm of interrupts in guest is likely useless anyway, and we can do it
>>> by binding a single gsi to many interrupts if we really want to.
>>>
>>>        
>> Applied and queued, thanks.
>>      
> I'm guessing we need this for 2.6.32 stable and 2.6.33 as well?
>    

That's what 'queued' means.

-- 
error compiling committee.c: too many arguments to function

