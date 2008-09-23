Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYIWVJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYIWVJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYIWVJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:09:12 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:22214 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbYIWVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:09:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LQnShakZ5aswjS1lNuVU8OS6K/3yfzx3FmcINaIq1dBXYibNg5Xuq/cGesPqX0eYOt
         j20iMyojF3aVTdRWsNRsjZYqgjVdJA9nj8p7yFfJ8PqmYq4qv7QbTBwawW+FJ3mTZl5l
         p/0smRhXaxponQ7uj1YsoYJKZoW0XPh1n2nMg=
Message-ID: <21d7e9970809231409r3fdd640h53a72a808266d220@mail.gmail.com>
Date: Wed, 24 Sep 2008 07:09:09 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: jkosina@suse.cz, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
In-Reply-To: <20080923.140519.268233735.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com>
	 <20080922.185902.80812984.davem@davemloft.net>
	 <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
	 <20080923.140519.268233735.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 7:05 AM, David Miller <davem@davemloft.net> wrote:
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Tue, 23 Sep 2008 16:29:16 +0200 (CEST)
>
>> On Mon, 22 Sep 2008, David Miller wrote:
>>
>> > So I went through the changes from 2.6.27-rc5 until the SHA1
>> > ID ec0c15afb41fd9ad45b53468b60db50170e22346 and there were
>> > definitely no E1000 or E1000E changes during that time.
>>
>> Some recent comments on [1] seem to indicate that this is somehow coupled
>> into prior problems/panics with Intel graphics.
>
> My current suspicion in all of this is either the GEM kernel patches
> or recent X server.
>

I don't think OpenSUSE was shipping any of the GEM bits.

Dave.

> However, the eeprom/nvram programming sequence seems non-trivial on
> the e1000e.  You have to execute a set of precise register writes
> and register polls to successfully write things out to the nvram.
>
> This makes something like a random scribble out to MMIO space less
> likely to cause this problem.
>
> Is there some linear mapping of the nvram that could be written to
> on these cards?
>
