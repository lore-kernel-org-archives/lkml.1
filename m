Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYHYQZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYHYQZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbYHYQZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:25:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:20699 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYHYQZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=c5SaCEtvhJqbwvxI+c0bIo405uUhVZenTG2IcNIITNCDNPuKJRJBtlhLGilGfr7ZZp
         vDnjhLA/RcTr9exHseQfmJsDGAFksissksZ2PbNvhcqLo0rDAHxFCCaosV1bvxsuBZgb
         BOm4idn/CO7+KnBIbYWJ9EEM+Ag1TIG+HuUZQ=
Message-ID: <5e50e1d60808250925i5fcfc5d2idbe694e9da1057a7@mail.gmail.com>
Date: Mon, 25 Aug 2008 21:55:22 +0530
From: "umesh kernel" <umesh.linuxkernel@gmail.com>
To: ctuxer <ctuxer@gmail.com>
Subject: Re: better support for EV-DO AC8700 800 M usbserial modem ??
Cc: linux-kernel@vger.kernel.org, eerpini@gmail.com,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20080825154946.GA8628@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <op.ugdhwas9jwzwy4@localhost.localdomain>
	 <20080825154946.GA8628@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 9:19 PM, Greg KH <greg@kroah.com> wrote:
> On Sun, Aug 24, 2008 at 09:41:33AM +0530, ctuxer wrote:
>> hi everyone ,
>>
>> i have been using the EVDO AC8700 modem (usbserial) with kernel 2.6.26.2 ,
>> it uses the 'option' module along with the generic usbserial module . Well
>> i am happy for the improved support for the modem handling in the new
>> kernels( like now i don have to modprobe with the vendor and product IDs )
>> , there is one point specific to this modem which is still not handled ,
>> ..... the modem switches between EVDO and CDMA mode when the signal
>> strength is low or when there is a bandwidth overload at the vendor's( the
>> service provider , bsnl in my case )  tower . This switch in the mode is
>> not recognised by the driver and the connection is lost once this switching
>> occurs . I have to restart the wvdial program to reconnect .
>>
>> But if the modem were in CDMA mode when i connect , then the connection is
>> not lost when the modem switches back from CDMA to EVDO . I really don know
>> enough to understand what is the difference between the two cases or what
>> can be done to improve the support for this usbserial modem , ... can
>> anyone help ?
>
> This looks like something the userspace side has to handle, the option
> driver is just a dumb "pass-through" type driver, it doesn't really
> control the modem at all.  The "control" channel on the modem allows
> this to happen, a userspace program drives this.
>
> good luck,
>
I am using the same EVDO modem, but using KPPP as dialer and using
option module(also tried airprime module after adding the vendor and
product ids ). I am not facing this. issue. Connection is fine when
switching occurs. I can see that whenever modem light turns from
GREEN(EVDO) to Orange(CDMA 1x RTT) or back , only the data rate is
changing but the conenction is fine. Please check with KPPP dialer and
enable the option "Auto reconnect".

Regards,
Umesh
