Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570AbZCKUgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbZCKUgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZCKUgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:36:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:19975 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZCKUgH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uoJbWi8qYLT+CB2NSiSdXyXv7jajza7azi9k0ITtQak86UVDrEW+phxrkgnuQ4dwD1
         U5XpIvbC7E+BMajDRc8BtwIJcnCrteh44j7dwj8ghp5TPEGja1ygsdeXRfUZEYAnOzN9
         BeYAyyg1f+avy7Po9kI03eVa4NAC/ALEKIq6s=
MIME-Version: 1.0
In-Reply-To: <20090311201337.GI25995@parisc-linux.org>
References: <20090311043659.GC25995@parisc-linux.org>
	 <alpine.LFD.2.00.0903111220200.32478@localhost.localdomain>
	 <20090311201337.GI25995@parisc-linux.org>
Date: Wed, 11 Mar 2009 13:36:05 -0700
X-Google-Sender-Auth: 490b5c53d0b546f9
Message-ID: <86802c440903111336v7b5c3e3jc5bb3afd9da8f42e@mail.gmail.com>
Subject: Re: [GIT PULL] PCI fixes for 2.6.29
From: Yinghai Lu <yinghai@kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 1:13 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Mar 11, 2009 at 12:22:56PM -0700, Linus Torvalds wrote:
>> On Tue, 10 Mar 2009, Matthew Wilcox wrote:
>> > These are the PCI fixes that have been piling up for the last week while
>> > Jesse's been on vacation.  I don't think there's anything questionable
>> > here.  All the patches have been posted to linux-pci.
>>
>> Grrr. It doesn't even compile cleanly:
>>
>> drivers/pci/quirks.c: In function ?ht_check_msi_mapping?:
>> drivers/pci/quirks.c:2142: warning: ?return? with no value, in function returning non-void
>>
>> and yes, it's a real bug.
>
> Agreed, it's a real bug.  I also think it should return 0, but I want
> Prakash to verify that, since I don't have a system of this nature.
>
> I wish this warning were an error.  According to the GCC docs,
> -Werror=return-type should do this, but it seems to have no effect.
>
>> I'm not happy.
>
> Me neither.  I'm sorry I didn't catch the warning.
>

please don't use that one. and use "pci: don't disable too many HT MSI
mapping -v4" instead

http://lkml.org/lkml/2009/3/5/458

YH
