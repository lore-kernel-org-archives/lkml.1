Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZCKEiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZCKEiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZCKEhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:37:51 -0400
Received: from kroah.org ([198.145.64.141]:57796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751347AbZCKEhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:37:50 -0400
Date: Tue, 10 Mar 2009 21:32:29 -0700
From: Greg KH <greg@kroah.com>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [v1 PATCH 1/1] PCI: Add AMD8111 PCI Bridge PCI Device ID
Message-ID: <20090311043229.GA25746@kroah.com>
References: <1236589743-4358-1-git-send-email-qingtao.cao@windriver.com> <1236589743-4358-2-git-send-email-qingtao.cao@windriver.com> <20090309194306.GC15011@kroah.com> <49B5C1B4.4040309@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49B5C1B4.4040309@windriver.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 09:26:12AM +0800, Harry Ciao wrote:
> Greg KH 写道:
>> On Mon, Mar 09, 2009 at 05:09:03PM +0800, Harry Ciao wrote:
>>   
>>> Add the PCI Device ID for the PCI Bridge Controller on AMD8111 chip,
>>> which is used by AMD8111 EDAC driver.
>>>     
>>
>> Where is the corrisponding change to the edac driver to use this new id?
>>
>>   
> This new id is to be used in the newly added edac driver amd8111_edac.c 
> that I have posted to the mailing list on March 9th, it is used to probe 
> the PCI Bridge Controller on AMD8111 chip.

So that patch depends on this one?  You should just use the device id
within your driver, no need to modify this header file at all.

>> And for ids that are only in one driver, there is no need to add them to
>> the pci_ids.h file.  This is what we have been doing for the past few
>> years in order to cut down on the merge-mess in the pci_ids.h file for
>> no reason.
>>
> Ok, I see for the time being I had better define this new id as a macro in 
> amd8111_edac.c.

Yes, as a permanent solution.

> And I am a little curious that do you mean that pci_ids.h maintainer
> would have to track how many times a new id have been requested to
> decide if to merge it into the file or not?

No, someone would notice it and submit such a patch.

thanks,

greg k-h
