Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502Ab0BYXPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:15:51 -0500
Received: from mail-iw0-f177.google.com ([209.85.223.177]:59328 "EHLO
	mail-iw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934472Ab0BYXPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:15:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I8QNRXe/zh7NDLNmMYRNZLFzWSw2hss+tXEkFYPkFCZU2ua5l+nNglZAfMzn80p3WG
         7p6fMcNCCLVgmKSXmnlJUdvvR5UaFj9TlyhDiL7iTR0Ugqs6jWtVdhGAgkvK+TubPKIp
         iBJLAp+gZiutMRksw8/cID+7NzGYrXUXAL1Cs=
MIME-Version: 1.0
In-Reply-To: <20100225161413.GA1229@kroah.com>
References: <4B7CAF95.6020306@gmail.com>
	 <SNT125-W36AFF0BF953EABAC9A0432C3400@phx.gbl>
	 <4B85EE88.5050506@kernel.org> <201002250503.09327.oliver@neukum.org>
	 <4B8609CE.5000705@kernel.org> <20100225161413.GA1229@kroah.com>
Date: Thu, 25 Feb 2010 17:15:49 -0600
Message-ID: <51f3faa71002251515k51354eb6y3e2cfd1558dba2f1@mail.gmail.com>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
From: Robert Hancock <hancockrwd@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>,
       Yuhong Bao <yuhongbao_386@hotmail.com>, david-b@pacbell.net,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 10:14 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Feb 25, 2010 at 02:25:34PM +0900, Tejun Heo wrote:
>> On 02/25/2010 01:03 PM, Oliver Neukum wrote:
>> > Am Donnerstag, 25. Februar 2010 04:29:12 schrieb Tejun Heo:
>> >> Arghhh.... I hate when intel pulls this type of 'product
>> >> differentiation' stunts.  At any rate, I'm doubtful swiotlb'ing for
>> >> usb2.0 would be noticeable at all.
>> >
>> > That can and should be tested.
>>
>> Robert did already.  Given that USB2.0 devices aren't usually used for
>> high-perf storage subsystem, the benefit looks marginal to me but
>> everyone is entitled to own opinion.

Those tests shouldn't be given too much weight, other than indicating
there is some measurable benefit. A more useful test would be on a
machine with more RAM and with device(s) that are pushing closer to
the limits of the USB bus.

>
> For now, I'd like to not enable this, given the huge risks and no known
> benifit.

"Huge risks" is likely a bit melodramatic, we've seen from the Windows
7 case that there are some problematic cases, but you can be fairly
aggressive about blacklisting controllers there. If Windows hadn't
adopted the feature one might argue there would be some risk going
into the future of this breaking on new machines, but we've seen that
Windows using the feature generally indicates it works..

>
> For USB 3.0, we can reconsider it, as it might start to make a
> difference there.

I'd say that's pretty certain..
