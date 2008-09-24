Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYIXJQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYIXJQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYIXJQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:16:27 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:43301 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYIXJQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=APT8K1tZ1Jho2KIhLA95TmrOmzbthEqAIEkADPu/OASGWAyonBPkqmryMM1taHePaq
         XmTrYLppCVhrAqxB1Hv23feQqKoNd1x66qovrEcraGo3E6ZhapqiWJQw7Hu7f+IdZIxz
         +BoDIMMbRf1kRSg7yrW/z9xzpXsksPX3F3h4I=
Message-ID: <21d7e9970809240216m4a93a339sb51a5928fcb5f6fb@mail.gmail.com>
Date: Wed, 24 Sep 2008 19:16:24 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: jkosina@suse.cz, jeffrey.t.kirsher@intel.com, david.vrabel@csr.com,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, chrisl@vmware.com
In-Reply-To: <20080924.020116.193720569.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970809232245x6a91c6e2l552ff039d07e2017@mail.gmail.com>
	 <20080924.003638.71148740.davem@davemloft.net>
	 <21d7e9970809240159u6db747eex51892061846b2251@mail.gmail.com>
	 <20080924.020116.193720569.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 7:01 PM, David Miller <davem@davemloft.net> wrote:
> From: "Dave Airlie" <airlied@gmail.com>
> Date: Wed, 24 Sep 2008 18:59:34 +1000
>
>> On Wed, Sep 24, 2008 at 5:36 PM, David Miller <davem@davemloft.net> wrote:
>> The driver seems quite happy to access the NVRAM, I think Thomas has
>> some backtraces that show
>> it clearly doing silly reentrant things...
>
> I don't dispute that the locking is dodgy and likely needs to be fixed
> like e1000.
>
> I'm asking what userland tool or kernel event is triggering the nvram
> access.
>
> It shouldn't even touch the thing after probing and initializing
> the card.

Hopefully tglx can supply some traces, I think getting an interrupt
during device startup
can possibly access the nvram

http://www.tglx.de/~tglx/wtf2.txt

seems to suggest bad things could happen.

Dave.
