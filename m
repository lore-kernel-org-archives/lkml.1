Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbXK0Fiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbXK0Fiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 00:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXK0Fir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 00:38:47 -0500
Received: from cantor.suse.de ([195.135.220.2]:60405 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbXK0Fiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 00:38:46 -0500
Message-ID: <474BAD5F.9050803@suse.de>
Date: Tue, 27 Nov 2007 14:38:39 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, andrew.patterson@hp.com,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Error returns not handled correctly by	sysfs.c:subsys_attr_store()
References: <1195683419.16019.225.camel@grinch> <20071126203116.0c93cdb9.akpm@linux-foundation.org> <20071127053321.GA975@kroah.com>
In-Reply-To: <20071127053321.GA975@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Nov 26, 2007 at 08:31:16PM -0800, Andrew Morton wrote:
>> On Wed, 21 Nov 2007 15:16:59 -0700 Andrew Patterson <andrew.patterson@hp.com> wrote:
>>
>>> The buf in fs/sysfs.c:subsys_attr_store() does not seem to be updated
>>> correctly when returning a negative value (indicating that an error
>>> condition has occurred) is returned.  If a negative value is returned,
>>> the next subsequent call to subsys_attr_store will have the contents of
>>> buf appended to the previous call.
>> subsys_attr_store() gets deleted by
>> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kset-kill-subsys-attr.patch
>>
>> So maybe we will soon accidentally fix whatever-this-is?  Or maybe we will
>> faithfully maintain it.
> 
> Yes, subsys attributes go away, but this is showing a bug in the sysfs
> core with attributes, not in the "middle" layers of attributes.
> 
> I bounced the original bug report to Tejun, who has been changing the
> logic around this area to see if he sees anything that might be
> different now.
> 
> Tejun?

(groaning buried under ATA bugs) Will take a look soon.

Thanks.

-- 
tejun
