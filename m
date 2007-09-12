Return-Path: <linux-kernel-owner+w=401wt.eu-S970736AbXILStY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970736AbXILStY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968588AbXILStO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:49:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:45740 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbXILStM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=E/3495BsAiIDtM+0MVW5CndDolI8nwRaXdwSmnnbwegydijToYIwo5dgI8ayQWvl5pP5k8NCb8vKZKXYW9k25AfwKW5UGZitFyaVb5uEPqLIf/EWFxkGdKL65WyI/QpSVr/OiqqfPxGiOD/3NXcIB87G3ZtRLobvDLBu4IDBeDw=
Message-ID: <46E834A2.2020205@gmail.com>
Date: Wed, 12 Sep 2007 20:49:06 +0200
From: Patrizio Bassi <patrizio.bassi@gmail.com>
Reply-To: patrizio.bassi@gmail.com
Organization: patrizio.bassi@gmail.com
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@redhat.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Andi Kleen <ak@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: libata not working for sis5533
References: <46D132C5.5000803@gmail.com> <6bffcb0e0708261627s12e5a9acqef92d0261264a40c@mail.gmail.com> <46D8921E.3010304@gmail.com> <46D89429.7080802@gmail.com> <20070902114032.7dbfb21a@the-village.bc.nu> <Pine.LNX.4.64.0709031957390.24179@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709061156220.25942@fbirervta.pbzchgretzou.qr> <46E26DAF.9020906@gmail.com> <Pine.LNX.4.64.0709081243050.25942@fbirervta.pbzchgretzou.qr> <46E3DA7E.7060709@gmail.com> <20070911154658.ab1fe162.akpm@linux-foundation.org> <Pine.LNX.4.64.0709122018400.22467@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709122018400.22467@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt ha scritto:
> On Sep 11 2007 15:46, Andrew Morton wrote:
>   
>> Patrizio Bassi <patrizio.bassi@gmail.com> wrote:
>>     
>>> Jan Engelhardt ha scritto:
>>>       
>>>> On Sep 8 2007 11:38, Patrizio Bassi wrote:
>>>>         
>>>>> Jan Engelhardt wrote:
>>>>>    
>>>>>           
>>>>>> I shall give this a spin too, since I happen to have sis5513. Just
>>>>>> booted this fresh ata-enabled system (a matter of mkinitrd). It has not
>>>>>> exploded yet.
>>>>>>      
>>>>>>             
>>>>> don't you have the "irq 14" issue?
>>>>>    
>>>>>           
>>>> No, does not seem so.
>>>>         
>>> For Alan, libata devs...hope can help debug...
>>> this is http://www.patriziobassi.it/downloads/libata_issue.jpg
>>>       
>> Looks more like a platform irq routing issue than an ata issue.
>>
>> Perhaps an x86 or an acpi person can help out with this.
>>     
>
> Patrizio, have you tried with the old IDE? (And without suspend at that...)
>
>
>   

yes yes old IDE works ok, but the suspend functionality is broken....
so, as i compile scsi subsystem for usb-storage i wanted to move to the
new libata, but i found this issue...

Patrizio

