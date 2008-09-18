Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYIRV46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYIRV46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYIRV4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:56:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:64551 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbYIRV4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:56:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=f/wiaURvt4OFNHYl4DROQ/GId5b88JECLxLeC8PJvODddvOraU5SIEjk0tzQ9J8014
         vtQU32AgA2P9U+aCKa71RdH+nBvCNp6Mno43NP+x+yA3RwxU3zR9TquIfR8vWJCWtO0S
         ZBCCIrftePUhkf03Z1gB2oVVwpHv3ds1MIrvY=
Message-ID: <e9f21eac0809181456l75e6bd1lc570328af6fcc8a0@mail.gmail.com>
Date: Thu, 18 Sep 2008 14:56:46 -0700
From: "April Tsui" <aprilla@gmail.com>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "David Brownell" <david-b@pacbell.net>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       Linux-usb <linux-usb@vger.kernel.org>,
       "Justin Mattock" <justinmattock@gmail.com>
In-Reply-To: <dd18b0c30809180957h2c8b7f33md73764b4ae2b890b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com>
	 <dd18b0c30809171714h23ba6c5wcba2146a9de088f@mail.gmail.com>
	 <dd18b0c30809172144s75bf684am951159218717972e@mail.gmail.com>
	 <200809180209.57943.david-b@pacbell.net>
	 <dd18b0c30809180957h2c8b7f33md73764b4ae2b890b@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please remove this email address from your discussions.

On Thu, Sep 18, 2008 at 9:57 AM, Justin Mattock <justinmattock@gmail.com> wrote:
> On Thu, Sep 18, 2008 at 2:09 AM, David Brownell <david-b@pacbell.net> wrote:
>> On Wednesday 17 September 2008, Justin Mattock wrote:
>>> http://www.gossamer-threads.com/lists/linux/kernel/966076
>>> I've applied the patches just to see what would happen,
>>> As for now I have not seen the Disable irq #23 yet,
>>
>> Those two patches should be in Greg's queue for 2.6.27...
>>
>> It's also suspicious that EHCI is getting loaded *last* not
>> first.  That's a common distro bug, although as I recall
>> we've always (since first driver versions) been clear that
>> it should be loaded first, before the companion (OHCI or UHCI)
>> driver.  Loading it last causes various confusions and races
>> at the hardware level.
>>
>> - Dave
>>
>
> I have not tried load ehci_hcd first in /etc/modules,
> but can try. As for the message itself  I've rebooted
> a couple of times without disable irq #23 going off.
>
>
> --
> Justin P. Mattock
>
