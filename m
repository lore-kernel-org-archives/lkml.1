Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbXLaQf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbXLaQf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 11:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXLaQfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 11:35:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46816 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbXLaQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 11:35:42 -0500
Message-ID: <47791A32.1020405@torque.net>
Date: Mon, 31 Dec 2007 11:34:58 -0500
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Bad escriptions in Kconfig
References: <alpine.LSU.0.999.0712311313050.3761@be1.lrz> <477907DB.8030406@torque.net> <20071231154731.GY11638@parisc-linux.org>
In-Reply-To: <20071231154731.GY11638@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Dec 31, 2007 at 10:16:43AM -0500, Douglas Gilbert wrote:
>> Bodo Eggert wrote:
>>> ---
>>> SCSI target support (SCSI_TGT) [N/m/y/?] (NEW) ?
>>>
>>> If you want to use SCSI target mode drivers enable this option.
>>> If you choose M, the module will be called scsi_tgt.
>>> ---
>>>
>>> What TF is a SCSI target mode, what is a target mode driver?
>> Heard of google :-)
>>
>> For explanations of SCSI (and other storage) terminology
>> reference could be made to SAM-3 or SAM-4 drafts (because
>> the real standards cost money) at www.t10.org .
>>
>> Perhaps many other subsections in the kernel could have
>> similar references.
> 
> I think that's an appalling idea.  Someone's trying to configure their
> kernel, not research hundreds of new ideas on the internet.  Here's a
> better description:
> 
> 	help
> 	  The SCSI target code allows your computer to appear as a SCSI
> 	  device.  This is useful in a SAN or NAS environment where you
> 	  want other computers to be able to treat this computer as a disc.
> 
> 	  To compile this driver as a module, choose M here: the module
> 	  will be called scsi_tgt.

Appalling or not, it is more accurate to define a SCSI target
properly than equate it to a direct access logical unit (i.e.
a disk). IMO the designers of that driver and associated
applications made exactly the same mistake which they are now
fixing. That driver is also transport specific with support
for iSCSI and iSER. Try writing a SPI, FC or SAS target driver
for scsi_tgt (I failed with SAS).

It could also be noted that if the reader doesn't understand
the description they can most likely say 'N'.

Doug Gilbert

