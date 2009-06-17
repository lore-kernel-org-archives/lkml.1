Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZFQRrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZFQRrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZFQRq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:46:59 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:18109 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZFQRq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:46:58 -0400
Message-ID: <4A392B48.7060206@oracle.com>
Date: Wed, 17 Jun 2009 10:43:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Matthew Wilcox <matthew@wil.cx>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: linux-next: Tree for June 17 (pci/slot)
References: <20090617155354.075c60ae.sfr@canb.auug.org.au>	<4A39194B.2060200@oracle.com>	<20090617163604.GT19977@parisc-linux.org> <20090617102901.6e39aac2@jbarnes-g45>
In-Reply-To: <20090617102901.6e39aac2@jbarnes-g45>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A392C0D.010D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Wed, 17 Jun 2009 10:36:04 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
>> On Wed, Jun 17, 2009 at 09:26:51AM -0700, Randy Dunlap wrote:
>>> Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20090616:
>>>
>>> When CONFIG_SYSFS=n:
>>>
>>> drivers/pci/slot.c:327: error: 'module_kset' undeclared (first use
>>> in this function)
>> Is there any point to pci_slot existing without CONFIG_SYSFS?
>> I don't see how you can interact with it in any meaningful way.
>> Perhaps CONFIG_PCI_SLOT should depend on CONFIG_SYSFS?
> 
> I've got a code fix queued up, but maybe a Kconfig dependency is the
> way to go...

What is the code fix like?
The Kconfig fix makes sense to me.


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
