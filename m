Return-Path: <linux-kernel-owner+w=401wt.eu-S933694AbYCFMhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694AbYCFMhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 07:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933415AbYCFMgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 07:36:54 -0500
Received: from mail.southpole.se ([193.12.106.18]:51798 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbYCFMgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 07:36:53 -0500
Message-ID: <47CFE561.2070104@southpole.se>
Date: Thu, 06 Mar 2008 13:36:49 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com
Subject: Re: struct pci_device_id declaration cleanups
References: <1204800947-21569-1-git-send-email-jonas@southpole.se> <20080306122518.GB28561@infradead.org>
In-Reply-To: <20080306122518.GB28561@infradead.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Mar 06, 2008 at 11:55:38AM +0100, Jonas Bonn wrote:
>> This set of patches applies the macro DECLARE_PCI_DEVICE_TABLE to the 
>> declarations of struct pci_device_id in several network drivers.  The drivers
>> build cleanly with these patches (without any new warnings) on both x86 and 
>> PowerPC.
> 
> Why would we want this macro?  It looks slightly ugly at least..
> 
> 

Basically because the alternative would be along the lines of:

static const struct pci_device_id fst_pci_dev_id[] __devinitconst = {

...and this was deemed to be even uglier when I first brought this up a 
while back.

/Jonas

