Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836Ab0ATOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab0ATOKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 09:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497Ab0ATOKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 09:10:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0ATOKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 09:10:40 -0500
Message-ID: <4B570EDD.6000808@redhat.com>
Date: Wed, 20 Jan 2010 16:10:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: mtosatti@redhat.com, Davide Libenzi <davidel@xmailserver.org>,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] kvm: fix spurious interrupt with irqfd
References: <20100113171222.GA19798@redhat.com> <4B5305CA.5070001@redhat.com> <20100119145202.GC28465@redhat.com>
In-Reply-To: <20100119145202.GC28465@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 04:52 PM, Michael S. Tsirkin wrote:
> On Sun, Jan 17, 2010 at 02:42:50PM +0200, Avi Kivity wrote:
>    
>> On 01/13/2010 07:12 PM, Michael S. Tsirkin wrote:
>>      
>>> Deassigning irqfd and assigning back caused spurious interrupt. fix this
>>> by clearing the counter on deassign.  This is on top of davidel's patch
>>> which makes clearing eventfd counter from modules possible.
>>>
>>>        
>> Applied both, thanks.
>>      
> Hmm, I see this in kvm master.  Avi/Marcelo, since this is a bugfix, can
> you queue this patchset for 2.6.33 and 2.6.32 stable as well please?
>    

I'm uncomfortable with pushing Davide's patch into stable and possibly 
causing regressions with unrelated applications.  Can't a guest live 
with a spurious interrupt?  It's not like they're unknown.

-- 
error compiling committee.c: too many arguments to function

