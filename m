Return-Path: <linux-kernel-owner+w=401wt.eu-S1756669AbZLCTFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbZLCTFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZLCTF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:05:29 -0500
Received: from claw.goop.org ([74.207.240.146]:34722 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756633AbZLCTF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:05:29 -0500
Message-ID: <4B180BFE.1000903@goop.org>
Date: Thu, 03 Dec 2009 11:05:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: jayakumar.lkml@gmail.com, damm@opensource.se, linux-kernel@vger.kernel.org,
       armbru@redhat.com
Subject: Re: [PATCH 1/3] fb-defio: If FBINFO_VIRTFB is defined, do not set
 VM_IO flag.
References: <1259854318-16907-1-git-send-email-konrad.wilk@oracle.com> <1259854318-16907-2-git-send-email-konrad.wilk@oracle.com> <4B180867.3050706@goop.org> <20091203185606.GB17342@phenom.dumpdata.com>
In-Reply-To: <20091203185606.GB17342@phenom.dumpdata.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/09 10:56, Konrad Rzeszutek Wilk wrote:
> On Thu, Dec 03, 2009 at 10:50:15AM -0800, Jeremy Fitzhardinge wrote:
>   
>> On 12/03/09 07:31, Konrad Rzeszutek Wilk wrote:
>>     
>>> Most users (except sh_mobile_lcdcfb.c) get their framebuffer from
>>> vmalloc. Setting VM_IO is not necessary as the memory obtained
>>> from vmalloc is System RAM type and is not susceptible to PCI memory
>>> constraints.
>>>   
>>>       
>> Looks good, but you forgot signoffs on these.  Do you want me to add them?
>>     
> Duh!! Please do. Thank you for noticing it.
>   

Already done ;)  Will merge into xen/master shortly.  I'd like to queue
this up for this merge window if Jaya is OK with it, and also mark for
stable.  Though I think fbdev overall is currently considered
maintainerless...

    J
