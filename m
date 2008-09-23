Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYIWB1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYIWB1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYIWB0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:26:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:48383 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYIWB0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:26:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v80odkCfwGcq0kmSw58YVAeas6WjiaH5V+vOpzy11EDPJ/5B3auhr8W1kEWvAuaLHe
         KpOesBKwpvvKg/qeGvDVdld3ZkgVOm6W5HctLPcU8DDryrjDnECozf2aUq6B2KpOVynV
         5AidqIQx/LI+794kj1wHVmGGSgyNHA1of+2Js=
Message-ID: <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com>
Date: Tue, 23 Sep 2008 11:26:52 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: jkosina@suse.cz, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com, david.vrabel@csr.com
In-Reply-To: <20080922.152815.22060684.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080921.165159.67476441.davem@davemloft.net>
	 <21d7e9970809212359y6876c405ub57dca3e9ee737e4@mail.gmail.com>
	 <Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz>
	 <20080922.152815.22060684.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 8:28 AM, David Miller <davem@davemloft.net> wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Tue, 23 Sep 2008 00:15:08 +0200 (CEST)
>
>> On Mon, 22 Sep 2008, Dave Airlie wrote:
>>
>> > Sep 8th I booted my own 2.6.27-rc5 kernel based from
>> > ec0c15afb41fd9ad45b53468b60db50170e22346
>> > This got a corrupted e1000e checksum and every kernel since has.
>>
>> Have you restored the EEPROM contents after it got corrupted for the first
>> time?
>>
>> Once the EEPROM contents get corrupted, the card will then be broken
>> forever even on kernel that gets this fixed one day.
>>
>> This is pretty serious bug in fact, as it renders hardware of poor users
>> unusable, and just patching kernel is then not enough to put things back
>> to shape.
>
> The top priority is to root cause this, so that we can stop the
> problem from happening as fast as possible, and I'm still waiting for
> the SHA1 ID that was used for the last kernel Dave booted before the
> problem occurred which is pretty damn critical for making forward
> progress here.

It was exactly 2.6.27-rc5 + Fedora at the time but we rarely touch
these areas, most of the extra code is in other places, and since
people are seeing it on !Fedora
also I would assume it wasn't these.

I think people have seen it on earlier kernels maybe but not sure.

really Intel needs to get a fix of some sort out so we can repair the
hw so we can root cause the probem.

Dave.

>
> It could even be some PCI or x86 layer change that caused the corruption,
> we don't even know yet.
>
