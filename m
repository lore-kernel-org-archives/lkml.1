Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbYFZVko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbYFZVko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYFZVkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:40:21 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:42694 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYFZVkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:40:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=seznam.cz;
	h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=GNU78MB1EwOlPWPCgMD0fKetIEN3/tFTuphFxPEwirztMF+Kk/azv+m5LxVC0uech
	dYc+X8TdPhyC9bTsqaRIg1QbASLQbT3CWU7ajKw993nq/Zk5KzyQXPYbE4069iTbHks
	5Fwj29uG664y1s+irdvyI+qZuosWUWCy2i9/RWo=
Message-ID: <48640CF7.7050700@seznam.cz>
Date: Thu, 26 Jun 2008 23:41:11 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: Jon Loeliger <jdl@freescale.com>, linux-arch@vger.kernel.org,
       john.williams@petalogix.com, arnd@arndb.de, vapier.adi@gmail.com,
       matthew@wil.cx, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       will.newton@gmail.com, hpa@zytor.com, John Linn <linnj@xilinx.com>,
       drepper@redhat.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>	<1214483429-32360-2-git-send-email-monstr@seznam.cz>	<1214483429-32360-3-git-send-email-monstr@seznam.cz>	<1214483429-32360-4-git-send-email-monstr@seznam.cz>	<1214483429-32360-5-git-send-email-monstr@seznam.cz>	<1214483429-32360-6-git-send-email-monstr@seznam.cz>	<1214483429-32360-7-git-send-email-monstr@seznam.cz>	<1214483429-32360-8-git-send-email-monstr@seznam.cz>	<1214483429-32360-9-git-send-email-monstr@seznam.cz>	<1214483429-32360-10-git-send-email-monstr@seznam.cz>	<1214483429-32360-11-git-send-email-monstr@seznam.cz>	<1214483429-32360-12-git-send-email-monstr@seznam.cz>	<1214483429-32360-13-git-send-email-monstr@seznam.cz><4863B096.7020309@freescale.com>	<4863E68C.30802@seznam.cz> <20080626201813.9662411E0051@mail20-wa4.bigfish.com>
In-Reply-To: <20080626201813.9662411E0051@mail20-wa4.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.1.1@13338
X-Seznam-User: monstr@seznam.cz
X-QM-Mark: email-qm3<130696345>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Thanks for information Steve.

Jon: Only for sure the main difference is only in value handling. Am I right?
If yes, it is easy to change.

M

> It's on my list of things to do, but I'm swamped with a few deadlines at
> the moment.
> 
> Steve
> 
>> -----Original Message-----
>> From: linuxppc-dev-bounces+stephen.neuendorffer=xilinx.com@ozlabs.org
> [mailto:linuxppc-dev-
>> bounces+stephen.neuendorffer=xilinx.com@ozlabs.org] On Behalf Of
> Michal Simek
>> Sent: Thursday, June 26, 2008 11:57 AM
>> To: Jon Loeliger
>> Cc: linux-arch@vger.kernel.org; alan@lxorguk.ukuu.org.uk;
> arnd@arndb.de; vapier.adi@gmail.com;
>> matthew@wil.cx; microblaze-uclinux@itee.uq.edu.au;
> linux-kernel@vger.kernel.org; drepper@redhat.com;
>> linuxppc-dev@ozlabs.org; will.newton@gmail.com; hpa@zytor.com; John
> Linn; john.williams@petalogix.com
>> Subject: Re: [PATCH 12/60] microblaze_v4: Generic dts file for
> platforms
>> OK. We have to change fdt generator with Steve.
>>
>> Steve: can you look at it?
>>
>> M
>>
>>
>>> monstr@seznam.cz wrote:
>>>> From: Michal Simek <monstr@monstr.eu>
>>>>
>>>>
>>>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>>> ---
>>>>  arch/microblaze/platform/generic/system.dts |  300
>>>> +++++++++++++++++++++++++++
>>>>  1 files changed, 300 insertions(+), 0 deletions(-)
>>>>  create mode 100644 arch/microblaze/platform/generic/system.dts
>>>>
>>>> diff --git a/arch/microblaze/platform/generic/system.dts
>>>> b/arch/microblaze/platform/generic/system.dts
>>>> new file mode 100644
>>>> index 0000000..724a037
>>>> --- /dev/null
>>>> +++ b/arch/microblaze/platform/generic/system.dts
>>>> @@ -0,0 +1,300 @@
>>>> +/*
>>>> + * (C) Copyright 2007-2008 Xilinx, Inc.
>>>> + * (C) Copyright 2007-2008 Michal Simek
>>>> + *
>>>> + * Michal SIMEK <monstr@monstr.eu>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or
>>>> + * modify it under the terms of the GNU General Public License as
>>>> + * published by the Free Software Foundation; either version 2 of
>>>> + * the License, or (at your option) any later version.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>>>> + * GNU General Public License for more details.
>>>> + *
>>>> + * You should have received a copy of the GNU General Public
> License
>>>> + * along with this program; if not, write to the Free Software
>>>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
>>>> + * MA 02111-1307 USA
>>>> + *
>>>> + * CAUTION: This file is automatically generated by libgen.
>>>> + * Version: Xilinx EDK 9.2.02 EDK_Jm_SP2.3
>>>> + * Generate by FDT v1.00.a
>>>> + */
>>>> +
>>>> +/ {
>>>> +    #address-cells = <1>;
>>>> +    #size-cells = <1>;
>>>> +    compatible = "xlnx,microblaze";
>>>> +    model = "testing";
>>>> +    DDR_SDRAM_32Mx16: memory@20000000 {
>>>> +        device_type = "memory";
>>>> +        reg = < 20000000 2000000 >;
>>>> +    } ;
>>>> +    chosen {
>>>> +        bootargs = "console=ttyUL0,115200 loglevel=15";
>>>> +        linux,stdout-path = "/plb@0/serial@40100000";
>>>> +    } ;
>>>> +    cpus {
>>>> +        #address-cells = <1>;
>>>> +        #cpus = <1>;
>>>> +        #size-cells = <0>;
>>>> +        microblaze_0: cpu@0 {
>>>> +            clock-frequency = <2faf080>;
>>>
>>> This should really be using the /dts-v1/ format now.
>>>
>>> Thanks,
>>> jdl
>>>
>>> _______________________________________________
>>> Linuxppc-dev mailing list
>>> Linuxppc-dev@ozlabs.org
>>> https://ozlabs.org/mailman/listinfo/linuxppc-dev
>>>
>>>
>>>
> ------------------------------------------------------------------------
>>>
>>> No virus found in this incoming message.
>>> Checked by AVG.
>>> Version: 8.0.101 / Virus Database: 270.4.1/1519 - Release Date:
> 25.6.2008 04:13
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@ozlabs.org
>> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 
> This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 
> 
> ------------------------------------------------------------------------
> 
> 
> No virus found in this incoming message.
> Checked by AVG. 
> Version: 8.0.101 / Virus Database: 270.4.1/1519 - Release Date: 25.6.2008 04:13
