Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYCaPCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYCaPCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYCaPCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:02:07 -0400
Received: from gw.goop.org ([64.81.55.164]:60069 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYCaPCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:02:06 -0400
Message-ID: <47F0FCB9.8050407@goop.org>
Date: Mon, 31 Mar 2008 08:01:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: chrisw@sous-sol.org, sct@redhat.com,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com
Subject: Re: [PATCH 12/12] xen: import arch generic part of xencomm.
References: <12067044183207-git-send-email-yamahata@valinux.co.jp> <12067044184070-git-send-email-yamahata@valinux.co.jp> <47ED508C.2000608@goop.org> <20080331094927.GI17609%yamahata@valinux.co.jp>
In-Reply-To: <20080331094927.GI17609%yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> On Fri, Mar 28, 2008 at 01:09:48PM -0700, Jeremy Fitzhardinge wrote:
>   
>> Isaku Yamahata wrote:
>>     
>>> On xen/ia64 and xen/powerpc hypercall arguments are passed by pseudo
>>> physical address (guest physical address) so that it's necessary to
>>> convert from virtual address into pseudo physical address. The frame
>>> work is called xencomm.
>>> Import arch generic part of xencomm.
>>>
>>> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
>>> ---
>>> drivers/xen/Makefile            |    1 +
>>> drivers/xen/xencomm.c           |  232 
>>> +++++++++++++++++++++++++++++++++++++++
>>> include/xen/interface/xencomm.h |   41 +++++++
>>> include/xen/xencomm.h           |   77 +++++++++++++
>>>  
>>>       
>> There's no Kconfig for this.
>>
>> What ends up using xencomm?  Could we defer adding it until there's an 
>> in-tree user?
>>     
>
> We are in a dilemma.
> ia64/xen needs xencomm so that it needs common xencomm code.
> However merging common xencomm code needs the real user i.e. ia64/xen.
>
> Another user of xencomm is powerpc/xen which isn't merged into
> upstream. So another choice would be
> - put the file into ia64 specific directory and
>   merge the file through linux-ia64.
>   When another user appears (possibly powerpc/xen),
>   move the file into common place (drivers/xen).
>
> We're now struggling for ia64/xen domU merge, so we want to make
> ia64/xen domU patch series as small as possible.
> Putting the file into drivers/xen is desirable for that.
> However either way is ok.
> Which way do you want (putting common dir or ia64 specfic dir)?

No, it's fine as-is.

    J
