Return-Path: <linux-kernel-owner+w=401wt.eu-S932124AbZEDQSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbZEDQSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZEDQSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:18:09 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:49982 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743AbZEDQSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:18:07 -0400
Message-ID: <49FF1596.2020503@oracle.com>
Date: Mon, 04 May 2009 09:19:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 4 (staging/comedi)
References: <20090504170810.64cdceb4.sfr@canb.auug.org.au> <49FF0EEA.1010605@oracle.com> <20090504161232.GB11723@kroah.com>
In-Reply-To: <20090504161232.GB11723@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49FF1536.0204,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, May 04, 2009 at 08:51:06AM -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20090501:
>>
>> build-r4048.out:ERROR: "ni_tio_rinsn" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
>> build-r4048.out:ERROR: "ni_tio_winsn" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
>> build-r4048.out:ERROR: "ni_tio_insn_config" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
>> build-r4048.out:ERROR: "ni_tio_init_counter" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
>> build-r4048.out:ERROR: "ni_gpct_device_construct" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
>> build-r4048.out:ERROR: "ni_gpct_device_destroy" [drivers/staging/comedi/drivers/ni_mio_cs.ko] undefined!
>> build-r4048.out:ERROR: "labpc_1200_is_unipolar" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> build-r4048.out:ERROR: "labpc_1200_ai_gain_bits" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> build-r4048.out:ERROR: "range_labpc_1200_ai" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> build-r4048.out:ERROR: "labpc_common_detach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> build-r4048.out:ERROR: "labpc_common_attach" [drivers/staging/comedi/drivers/ni_labpc_cs.ko] undefined!
>> build-r4048.out:ERROR: "das08_cs_boards" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
>> build-r4048.out:ERROR: "das08_common_detach" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
>> build-r4048.out:ERROR: "das08_common_attach" [drivers/staging/comedi/drivers/das08_cs.ko] undefined!
>>
>>
>> config attached.
> 
> CONFIG_PCMCIA is allowed to be set without CONFIG_PCI?  That sounds like
> the problem there (not to mention pretty much an impossible real-world
> combination...)

PCMCIA is (was?) a 16-bit ISA-like bus.
That's not PCCard (PCI-like).


-- 
~Randy
