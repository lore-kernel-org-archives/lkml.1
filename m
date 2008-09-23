Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYIWWMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYIWWMy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYIWWMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:12:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:46031 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbYIWWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=O+kRslnApAHlWdQacjE9vNwkq3cJZWPHgzLOBNRiMTxLtUyaFGQTdkOmm8ichXBqZV
         +Hu5/QJRya1QJgfg0nGT0yCppXdDPE6HaGY+f50pjOX8kfm3MfeHk7FGUFasuG8RcXXT
         TgGj4soA3Nqrb5JsrtaD3koPkX0UbylCT7oyc=
Message-ID: <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>
Date: Tue, 23 Sep 2008 15:12:43 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: airlied@gmail.com, jkosina@suse.cz, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
In-Reply-To: <20080923.150722.141587696.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
	 <20080923.140519.268233735.davem@davemloft.net>
	 <21d7e9970809231409r3fdd640h53a72a808266d220@mail.gmail.com>
	 <20080923.150722.141587696.davem@davemloft.net>
X-Google-Sender-Auth: 21da3f72bde522c2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 3:07 PM, David Miller <davem@davemloft.net> wrote:
> From: "Dave Airlie" <airlied@gmail.com>
> Date: Wed, 24 Sep 2008 07:09:09 +1000
>
>> On Wed, Sep 24, 2008 at 7:05 AM, David Miller <davem@davemloft.net> wrote:
>> > From: Jiri Kosina <jkosina@suse.cz>
>> > Date: Tue, 23 Sep 2008 16:29:16 +0200 (CEST)
>> >
>> >> On Mon, 22 Sep 2008, David Miller wrote:
>> >>
>> >> > So I went through the changes from 2.6.27-rc5 until the SHA1
>> >> > ID ec0c15afb41fd9ad45b53468b60db50170e22346 and there were
>> >> > definitely no E1000 or E1000E changes during that time.
>> >>
>> >> Some recent comments on [1] seem to indicate that this is somehow coupled
>> >> into prior problems/panics with Intel graphics.
>> >
>> > My current suspicion in all of this is either the GEM kernel patches
>> > or recent X server.
>> >
>>
>> I don't think OpenSUSE was shipping any of the GEM bits.
>
> Good data point, can someone confirm this?  Also, what X server version
> is the effected OpenSUSE shipping?
> --


OpenSuSE 11 ships x server version 7.3.

-- 
Cheers,
Jeff
