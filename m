Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0CBPkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:40:08 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:60496 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0CBPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:40:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MASDYeciRNYkfjya3IuvEKYfBrFnHIaKOdOLZEL8p/BJKKxZyE/7noqpfkBKLTZC6X
         S05AcrggihKzZ+Kgou9f951Du85G7OnCOi8XZMPnt4qeY69mVar3o2dwXaLw+cI0WrsQ
         fheIj1MXexdg25rTCbNEJMXsvqcwQ5pMctv68=
Date: Tue, 2 Mar 2010 23:42:56 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Oleg Kutkov <elenbert@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Notifier chains bug ?
Message-ID: <20100302153651.GC4014@hack>
References: <4B8C56F0.5090700@gmail.com> <2375c9f91003011924k43f03649y5b4df405d6247a79@mail.gmail.com> <5e9821061003012150y15e543cdkf6f23c3a7a47e4a3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e9821061003012150y15e543cdkf6f23c3a7a47e4a3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 07:50:01AM +0200, Oleg Kutkov wrote:
>2010/3/2 Américo Wang <xiyou.wangcong@gmail.com>:
>> On Tue, Mar 2, 2010 at 8:08 AM, Oleg Kutkov <elenbert@gmail.com> wrote:
>>> Hello.
>>> I try to used notifier chains for monitoring network devices events.
>>> All works perfectly when just i'm connecting/disconnecting network cable or
>>> up/down interface via ifconfig.
>>> But when i try to change interface address - nothing happens. Notifier is
>>> don't send any events :(
>>
>> I think you mean IP address? No, NETDEV_CHANGEADDR is for hardware
>> address, not for IP address.
>>
>> If you were changing mac address, you will receive NETDEV_CHANGEADDR.
>>
>
>Thank for quick answer.
>Yes, i mean IP address. And what about NETDEV_CHANGE ?

It is for rtnetlink state transition.

>Is there possible for monitoring IP address/netmask changing ?
>

AFAIK, no.

Cc'ing netdev experts...
