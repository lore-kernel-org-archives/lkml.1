Return-Path: <linux-kernel-owner+w=401wt.eu-S1030227AbXBZN0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbXBZN0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030225AbXBZN0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:26:01 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:11905 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030227AbXBZN0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:26:00 -0500
Date: Mon, 26 Feb 2007 08:24:57 -0500
To: "Yakov Lerner" <iler.ml@gmail.com>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
From: "Sorin Faibish" <sfaibish@emc.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "piernas@ditec.um.es" <piernas@ditec.um.es>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com> <op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com> <f36b08ee0702260349p284f0886n7a1987cfdd43bf55@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Message-ID: <op.tocx7va5rwwil4@muki-1mj5c5mxes>
In-Reply-To: <f36b08ee0702260349p284f0886n7a1987cfdd43bf55@mail.gmail.com>
User-Agent: Opera Mail/9.00 (Win32)
X-PMX-Version: 4.7.1.128075, Antispam-Engine: 2.5.0.283055, Antispam-Data: 2007.2.26.50933
X-PerlMx-Spam: Gauge=, SPAM=0%, Reasons='EMC_BODY_1+ -3, EMC_FROM_0+ -2, __C230066_P5 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Feb 2007 06:49:05 -0500, Yakov Lerner <iler.ml@gmail.com> wrote:

> On 2/14/07, sfaibish <sfaibish@emc.com> wrote:
>> On Sat, 10 Feb 2007 22:06:37 -0500, Sorin Faibish <sfaibish@emc.com>  
>> wrote:
>>
>> > Introducing DualFS
>> >
>> > File System developers played with the idea of separation of
>> > meta-data from data in file systems for a while. The idea was
>> > lately revived by a small group of file system enthusiasts
>> >  from Spain (from the little known University of Murcia) and
>> > it is called DualFS. We believe that the separation idea
>> > will bring to Linux file systems great value.
>> >
>> > We see DualFS as a next-generation journaling file system which
>> > has the same consistency guaranties as traditional journaling
>> > file systems but better performance characteristics. The new file
>> > system puts data and meta-data on different devices (usually, two
>> > partitions on the same disk or different disks)
>
> Do you guys have an option of using just one partiton, and
> divide it into two fixed parts at mkfs-time , one part X% (for metadata)
> and  2nd part at (100-X)% (file file  blocks) ?

 From an ease-of-use perspective I agree as this could be an option
but the point is to be able to manage the MD completely separate
in cases when you want for example to extend the MD volumes or
data volumes independently for example. It is all about different
address spaces and fencing. I am not sure is good for fsck tasks.

> Would not this option
> be easier-to-administer choice for naive users ?
 From a code perspective should be possible. We could put it on a TODO
list if of interest for many. It is not a matter of naive users
or not. We are all naive when we use FS and are not experts in FS.

> Or, you do not
> view your FS as an option for naive users in the first place
If we are all naive of course we want DualFS to be useful for
all. We are open for proposed features and criticism from
the community. It is just a mater of resources.

>
> Yakov
>
>
>



-- 
Best Regards
  Sorin Faibish
Senior Technologist
Senior Consulting Software Engineer Network Storage Group

        EMC²            where information lives

Phone: 508-435-1000 x 48545
Cellphone: 617-510-0422
Email : sfaibish@emc.com

