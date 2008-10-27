Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbYJ0Xf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbYJ0Xf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 19:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYJ0XfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 19:35:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:55064 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYJ0XfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 19:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XU9soI1ivR0+qJ349f13GihIiLHRTp+aV47b4L7q4ijxvy9xw19i2dyGb+8SeAOp/O
         Hk5VtCn08dZbGiIgGCZXybkoixxiD3SqZ96Tfc/+3qe8znLof+txdLG7slBySHJu2bo6
         MZajs39gjGYZxwSMSpfvxfmC0P1N54XXaCUGo=
Message-ID: <43e72e890810271635i5b6dd6e4ua06b48e624991435@mail.gmail.com>
Date: Mon, 27 Oct 2008 16:35:11 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [otus-devel] Release of Atheros 802.11n USB Linux driver
Cc: "otus-devel@lists.madwifi-project.org" 
	<otus-devel@venema.h4ckr.net>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Joey Krane" <linuxbsd2004@gmail.com>
In-Reply-To: <20081023111103.GB5979@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890810211904x7bd243dem68dfcfe7a795ec6f@mail.gmail.com>
	 <20081022065045.GA2400@kroah.com> <20081023062655.GA8039@kroah.com>
	 <20081023111103.GB5979@tesla>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 4:11 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Oct 22, 2008 at 11:26:55PM -0700, Greg KH wrote:
>> On Tue, Oct 21, 2008 at 11:50:45PM -0700, Greg KH wrote:
>> > On Tue, Oct 21, 2008 at 07:04:17PM -0700, Luis R. Rodriguez wrote:
>> > > We would like to see our Atheros 802.11n USB Linux driver upstream
>> > > however we need help with this so we are releasing our Atheros 11n USB
>> > > Otus Linux driver under the ISC to the community. The goal is to work
>> > > with the community to help move this forward upstream. We are hoping
>> > > for community help and leadership on this (*cough*).
>> >
>> > Yeah!
>> >
>> > I'll grab this and put it in drivers/staging/ so it gets some users and
>> > more developers to help out with it.
>>
>> Ok, it seems to need some basic work to merely build properly on
>> "modern" kernel versions.
>
> Yeah, it works up to 2.6.24.

This is now fixed on the master branch, also the branch "for-upstream"
does a lot of cleanup I thought you may like before stuffing it into
staging like removing all KERNEL_VERSION checks, all wireless
extensions checks, some compile warnings, removal of compat, dos2unix,
use utf-8, etc. Unfortunately this still requires a specific version
of wpa_supplicant but it seems it works. Not sure what bars you have
for staging at this point.

Will you take this in, and expect patches for fixing it to use
standard wext and also report standard wireless statistic (yeap, this
is not there yet either).

Joey is one user which reported the driver working now with the
compile fixes for newer kernels for 2.6.28-rc2 using the specific
version of wpa_supplicant for it.

Joey can you test the for-upstream branch on otus git?

  Luis
