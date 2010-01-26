Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683Ab0AZVqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0AZVqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629Ab0AZVqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:46:48 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:59166 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0AZVqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:46:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HERbozlXIgiHpHwdyWIIB2l/0ZGJdsfcrsTFVpEwMzPLfdftb1owL5AHa+rOzQtvfG
         qq24fxj/u+mVtywD7RtVbYPAHf7Ro5/my9oxZANNwvDvxHIRJHtekB8DzDINMiO5egc2
         uoP09SymOtBE0FS/tYkQoXKDIC25iV5yJdQ7E=
Message-ID: <4B5F62C2.4000800@pobox.com>
Date: Tue, 26 Jan 2010 16:46:42 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Vishal Rao <vishalrao@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org, stable@kernel.org
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com> <20100126160243.018b87e3@lxorguk.ukuu.org.uk> <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
In-Reply-To: <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 11:19 AM, Vishal Rao wrote:
> 2010/1/26 Alan Cox<alan@lxorguk.ukuu.org.uk>:
>>> Should work with 64, 128 (tested) and 256 GB capacities with any
>>> firmware versions in
>>> drivers/ata/libata-core.c because of ATA errors in dmesg, hangs and
>>> filesystem corruption.
>>
>> If you've only tested one type why list all three ? Also you've not
>> listed a firmware version so do you know which are affected ?
>>
>> What controllers did you test with ?
>>
>> Alan
>>
>
> The 3 IDs should match I believe and the firmware parameter is NULL.
> Affected firmware versions include at least the latest 1916 and the
> previous 1819, likely older ones as well.
>
> Tested with my own Crucial CT128M225 model which has the IndiLinx
> Barefoot controller.

By controller, I think Alan meant the host controller (ata_piix, ahci, 
etc.)?

	Jeff



