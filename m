Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbZHZS07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbZHZS07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbZHZS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:26:58 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:64502 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZHZS06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:26:58 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 14:26:58 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R+o+A6N86Zq5DstVswa03MwQifJDEfOtqri0LaVUy09PcTZP5mdiQ1Li75d+fuDoHH
         VFzibbq6lgs+GBiHbVvHBy7kQqnILDWMpGlGvnlmVj0iKAzv+gHfkw+p5k4EdqPJdgyu
         wABai0FMqwWTF7T6nWVGVM0BjIYcp8S7+Va1s=
MIME-Version: 1.0
In-Reply-To: <20090826064545.GA7023@kroah.com>
References: <4746469c0908251817u225609bax66ea27261a1ef038@mail.gmail.com>
	 <20090826064545.GA7023@kroah.com>
Date: Wed, 26 Aug 2009 11:19:11 -0700
Message-ID: <4746469c0908261119m6f3edbd3ya6c7f483d434df16@mail.gmail.com>
Subject: Re: expresscard hotplug not working
From: Mike Mohr <akihana@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpiphp fails to load (claiming no such device).  pciehp is loaded but
dmesg doesn't indicate that any hardware is found by the driver -- it
only shows a status message stating that the driver is loaded.

Thanks,
Mike

On Tue, Aug 25, 2009 at 11:45 PM, Greg KH<greg@kroah.com> wrote:
> On Tue, Aug 25, 2009 at 06:17:28PM -0700, Mike Mohr wrote:
>> Hi,
>>
>> I think I'm having a similar problem to the fellow listed here:
>>
>> http://kerneltrap.org/mailarchive/linux-kernel/2007/10/16/344543
>>
>> The only difference is that no card will work at all unless it is
>> inserted before system power is turned on.  If the card is removed
>> while the system is running it stops working and will never return to
>> life unless the system is rebooted with the card in the slot.
>>
>> My kernel is configured exactly as this page describes:
>>
>> http://www.gentoo-wiki.info/ExpressCard
>>
>> However, I do not receive anything in dmesg except the reports of the
>> driver being unloaded and/or loaded.  Attempts to insert the card
>> after the machine is up elicit no kernel messages.  I'm thinking there
>> may be a missing PCI ID somewhere in the pciehp/pci_hotplug driver(s),
>> but I could well be mistaken.
>
> Do you have the acpiphp or pciehp driver loaded before trying to insert
> your card?
>
> thanks,
>
> greg k-h
>
