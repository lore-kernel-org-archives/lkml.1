Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbYJQBj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbYJQBj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 21:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYJQBjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 21:39:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58765 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYJQBjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 21:39:18 -0400
Message-ID: <48F7EC7B.5080703@jp.fujitsu.com>
Date: Fri, 17 Oct 2008 10:38:03 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Oliver Neukum <oliver@neukum.org>,
       linux-pci <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: question about pci_disable_device
References: <200810131947.44992.oliver@neukum.org> <20081014212608.GA14596@ldl.fc.hp.com>
In-Reply-To: <20081014212608.GA14596@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Hi Oliver,
> 
> * Oliver Neukum <oliver@neukum.org>:
>> Hi,
>>
>> could somebody explain what determines when in the sequence of hot
>> unplugging pci_disable_device() is called?
> 
> I don't know the answer, but you might have better luck cc'ing
> the linux-pci list too.
> 

When a pci device is hot unplugged, .remove callback of the
corresponding adapter card driver. It calls pci_disable_device().

Thanks,
Kenji Kaneshige


