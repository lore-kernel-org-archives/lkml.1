Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZCJBi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZCJBi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZCJBis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:38:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:35867 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZCJBir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:38:47 -0400
Message-ID: <49B5C1B4.4040309@windriver.com>
Date: Tue, 10 Mar 2009 09:26:12 +0800
From: Harry Ciao <qingtao.cao@windriver.com>
Reply-To: qingtao.cao@windriver.com
Organization: Wind River, CDC
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [v1 PATCH 1/1] PCI: Add AMD8111 PCI Bridge PCI Device ID
References: <1236589743-4358-1-git-send-email-qingtao.cao@windriver.com> <1236589743-4358-2-git-send-email-qingtao.cao@windriver.com> <20090309194306.GC15011@kroah.com>
In-Reply-To: <20090309194306.GC15011@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Mar 2009 01:38:21.0523 (UTC) FILETIME=[E5533230:01C9A120]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please see my answers below.


Greg KH 写道:
> On Mon, Mar 09, 2009 at 05:09:03PM +0800, Harry Ciao wrote:
>   
>> Add the PCI Device ID for the PCI Bridge Controller on AMD8111 chip,
>> which is used by AMD8111 EDAC driver.
>>     
>
> Where is the corrisponding change to the edac driver to use this new id?
>
>   
This new id is to be used in the newly added edac driver amd8111_edac.c 
that I have posted to the mailing list on March 9th, it is used to probe 
the PCI Bridge Controller on AMD8111 chip.

> And for ids that are only in one driver, there is no need to add them to
> the pci_ids.h file.  This is what we have been doing for the past few
> years in order to cut down on the merge-mess in the pci_ids.h file for
> no reason.
>
> thanks,
>
> greg k-h
>
>   
Ok, I see for the time being I had better define this new id as a macro 
in amd8111_edac.c.

And I am a little curious that do you mean that pci_ids.h maintainer 
would have to track how many times a new id have been requested to 
decide if to merge it into the file or not?

Thank you very much for your comments!

Best regards,

Harry


