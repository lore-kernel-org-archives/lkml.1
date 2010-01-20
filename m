Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724Ab0ATDPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0ATDPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 22:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539Ab0ATDPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 22:15:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:48772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab0ATDPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 22:15:12 -0500
Message-ID: <4B5676A9.2070808@kernel.org>
Date: Wed, 20 Jan 2010 12:21:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeff Garzik <jgarzik@pobox.com>, Seth Heasley <seth.heasley@intel.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel
 	Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>	 <4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>	 <51f3faa71001131611y343ad225n1acc73900fd49894@mail.gmail.com>	 <51f3faa71001131642u2cc9de80n8e73be7a8707afb2@mail.gmail.com>	 <20100114201136.GA3814@khazad-dum.debian.net> <51f3faa71001141615k3223a02fhb0b882b6cbe680cf@mail.gmail.com>
In-Reply-To: <51f3faa71001141615k3223a02fhb0b882b6cbe680cf@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 03:15:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2010 09:15 AM, Robert Hancock wrote:
> On Thu, Jan 14, 2010 at 2:11 PM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
>> On Wed, 13 Jan 2010, Robert Hancock wrote:
>>> Hmm, it seems like it's a bit more complicated than that. For ICH6R
>>> (0x2652), ata_piix attaches to it regardless of mode intentionally, it
>>> has specific logic to disable AHCI on the controller since it can be
>>> used in either mode. That seems a bit questionable. Having the same
>>> device being handled by different enabled drivers and depending on
>>> link or module load order to decide which one loads is fragile and
>>> prone to errors. I'd be in favor of removing the ICH6R support from
>>> ata_piix entirely and saying that you should be using ahci for that
>>> device. Maybe when ahci was immature there was a benefit to allowing
>>> ata_piix to run it, but I doubt that's true today.
>>
>> Maybe it is the silicon AHCI in ICH6R that is immature, and one is much
>> better of using it in IDE mode?
> 
> That seems unlikely, since the Intel-provided Matrix Storage drivers
> for that controller on Windows will be using AHCI mode..

Oh, some ich6 ahcis are very not very mature.  I have a ich6 which can
do ATA in ahci mode fine but craps out on ATAPI (it ends up spitting
out garbage FISes on the wire).  It works fine in piix mode.
ich6 is a dying strange beast.

Thanks.

-- 
tejun
