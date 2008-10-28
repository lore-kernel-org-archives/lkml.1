Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbYJ1FzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbYJ1FzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 01:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYJ1FzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 01:55:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:27472 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbYJ1FzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 01:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oitOhhcGsPFDUWMI+n38PbautL2lB48Xdohy0/tOIa72fFpYp5/f1gT6Ts6ZW6iBiS
         Z0OYkQJtJpCR0yyGnxPUVkzQilq3TQo5/hmFuEk09iJoZfEXZ7racN//9T08MmbHNskj
         j9BOG5NOBidBeAbOrVvJuuvcghMSfPwhpts0U=
Message-ID: <2411f6b20810272254u4c13efb7w1cf8fb68145fcb14@mail.gmail.com>
Date: Tue, 28 Oct 2008 11:24:59 +0530
From: "Joey Krane" <linuxbsd2004@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "otus-devel@lists.madwifi-project.org" 
	<otus-devel@venema.h4ckr.net>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <20081028002919.GB2992@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com>
	 <20081022065045.GA2400@kroah.com> <20081023062655.GA8039@kroah.com>
	 <20081023111103.GB5979@tesla>
	 <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com>
	 <20081028002919.GB2992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 5:59 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 27, 2008 at 04:35:11PM -0700, Luis R. Rodriguez wrote:
>> On Thu, Oct 23, 2008 at 4:11 AM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > On Wed, Oct 22, 2008 at 11:26:55PM -0700, Greg KH wrote:
>> >> On Tue, Oct 21, 2008 at 11:50:45PM -0700, Greg KH wrote:
>> >> > On Tue, Oct 21, 2008 at 07:04:17PM -0700, Luis R. Rodriguez wrote:
>> >> > > We would like to see our Atheros 802.11n USB Linux driver upstream
>> >> > > however we need help with this so we are releasing our Atheros 11n USB
>> >> > > Otus Linux driver under the ISC to the community. The goal is to work
>> >> > > with the community to help move this forward upstream. We are hoping
>> >> > > for community help and leadership on this (*cough*).
>> >> >
>> >> > Yeah!
>> >> >
>> >> > I'll grab this and put it in drivers/staging/ so it gets some users and
>> >> > more developers to help out with it.
>> >>
>> >> Ok, it seems to need some basic work to merely build properly on
>> >> "modern" kernel versions.
>> >
>> > Yeah, it works up to 2.6.24.
>>
>> This is now fixed on the master branch, also the branch "for-upstream"
>> does a lot of cleanup I thought you may like before stuffing it into
>> staging like removing all KERNEL_VERSION checks, all wireless
>> extensions checks, some compile warnings, removal of compat, dos2unix,
>> use utf-8, etc. Unfortunately this still requires a specific version
>> of wpa_supplicant but it seems it works. Not sure what bars you have
>> for staging at this point.
>
> Pretty much the only "bar" is "it compiles" :)
>
>> Will you take this in, and expect patches for fixing it to use
>> standard wext and also report standard wireless statistic (yeap, this
>> is not there yet either).
>
> Yes, I can do that.
>
>> Joey is one user which reported the driver working now with the
>> compile fixes for newer kernels for 2.6.28-rc2 using the specific
>> version of wpa_supplicant for it.
>>
>> Joey can you test the for-upstream branch on otus git?
>
> If someone can tell me what device this is for, I can try to go buy it
> so that I can verify changes I make don't drasticly break things.
>

I've tested the TL-WN821N (it's the cheapest N USB I think) with a
generic 802.11g router (WPA enabled) on 2.6.24.7, 2.6.27.4 and
2.6.28-rc2.

http://www.newegg.com/Product/Product.aspx?Item=N82E16833704032

I'll test the for-upstream branch soon.

Joey
