Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYIVQVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYIVQVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYIVQU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:20:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:27084 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYIVQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=msJnsBLdFr2VZpAo2uT2xITvfmkf0yoFCerSqYdCgum6VOagvhSgad4cvusGnDSU9p
         wXdGaPZAWB5HHMmcewuiuYZ/YweEX7/82lk7kCroi4Tp0o7jvTxxHaDoMsOrJkMbKL64
         3VKfme/G/KNgKXD488SN16NuA+IDDT2eq9ABY=
Message-ID: <dd18b0c30809220920j7bd47167ibcc4ca72bae239f0@mail.gmail.com>
Date: Mon, 22 Sep 2008 09:20:55 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [Bug #11552] Disabling IRQ #23
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>
In-Reply-To: <Pine.LNX.4.44L0.0809220651080.13379-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809211616g658b50c8k2ea9f9953f1de96f@mail.gmail.com>
	 <Pine.LNX.4.44L0.0809220651080.13379-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 3:53 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 21 Sep 2008, Justin Mattock wrote:
>
>> From over here, I did a bad install
>> of isight-firmware-tools, causing hal and udev
>> to clash.  After making sure the package was either
>> using hal or udev, there is no message of disable irq #23.
>> If its not too much trouble is there a way to verify that this was
>> the case, i.g. if udev creates a dev, then hal creates the same device
>> will this cause ehci_hcd to have messages of this kind? If so
>> then thats what happened, if not then theres something else causing this.
>
> You didn't read what I wrote earlier, did you?  The "HC died" message
> should NEVER occur!  It doesn't matter what games you play with hal and
> udev -- it should NEVER occur.  Not ever.
>
> And since the "HC died" is what causes IRQ #23 to be disabled, that
> shouldn't happen either.
>
> Alan Stern
>
>

appologize for not fully understanidng,
I'm just getting confused with why and what is causing this
to occur. The only reason for playing with hal and udev
is to have this message appear, if I leave them out of the picture
the system runs fine.
Anyways, I'm up to trying anything at this point, and again
appologize for causing any heat.

-- 
Justin P. Mattock
