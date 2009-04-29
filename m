Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZD2Xx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZD2Xx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZD2XxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:53:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:7061 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbZD2XxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vHB6t01zgoADH155iUnbAauSdn96x5PhCAfw1iBKEn40WIgYVPizHv3jyptOU/UBLP
         In+xWlenjreSQrD9u8dkZzYD5/5wOmRbT3phpzX1BW138JCmbHCskLLJWp8JkrSx4ubb
         yXD7fFNHEjCA9bQ3lR75UcLcYAyZTfJpVRbIw=
MIME-Version: 1.0
In-Reply-To: <20090429181657.GA30078@kroah.com>
References: <200904271943.40588.david-b@pacbell.net>
	 <20090429040810.GI23062@kroah.com>
	 <d82e647a0904290508l1b313389qcaf41c5d10f9abcd@mail.gmail.com>
	 <20090429181657.GA30078@kroah.com>
Date: Thu, 30 Apr 2009 07:53:17 +0800
Message-ID: <d82e647a0904291653x2990ee4u3133daec0ee74017@mail.gmail.com>
Subject: Re: [patch 2.6.30-rc3] platform_bus: remove "which platform_data?" 
	confusion
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/30 Greg KH <greg@kroah.com>:
> On Wed, Apr 29, 2009 at 08:08:10PM +0800, Ming Lei wrote:
>> 2009/4/29 Greg KH <greg@kroah.com>:
>> >
>> > Ming, what do you think of this?
>>
>> I did not know platform_data field can be used in other bus , so please
>> revert the previous patches.
>
> So that would be the following 2 commits, right:
>        ce21c7bcd796fc4f45d48781b7e85f493cc55ee5
>        006f4571a15fae3a0575f2a0f9e9b63b3d1012f8
> anything else I need to revert as well?

Also you need to drop
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core.current/driver-core-platform-do-not-complain-for-platform_data-added-by-platform_device_add_data.patch.

Thanks!

-- 
Lei Ming
