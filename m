Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYIWVEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYIWVEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYIWVDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:03:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:22087 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYIWVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NvShutAja5gvouwcsslw7FcRN9zcRVQZbszlEKq+sTzUJf5q4eJOQY+hAZRAmZZGxS
         5rbQQfdWEUJcjmYgPRu020DimvbbeWHtSNETVAlcjKPvpKW3DK3iR4420TY3xEZaRURu
         mYIU37/ppQWaQt/WQCp5zveN1kms+j4e04/Is=
Message-ID: <21d7e9970809231403wf766660u39908aca70548ca7@mail.gmail.com>
Date: Wed, 24 Sep 2008 07:03:53 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Cc: "David Miller" <davem@davemloft.net>, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com
In-Reply-To: <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809230010460.27884@twin.jikos.cz>
	 <20080922.152815.22060684.davem@davemloft.net>
	 <21d7e9970809221826i76081719pdd749237580fc68e@mail.gmail.com>
	 <20080922.185902.80812984.davem@davemloft.net>
	 <alpine.LNX.1.10.0809231229460.4671@pegasus.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 12:29 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 22 Sep 2008, David Miller wrote:
>
>> So I went through the changes from 2.6.27-rc5 until the SHA1
>> ID ec0c15afb41fd9ad45b53468b60db50170e22346 and there were
>> definitely no E1000 or E1000E changes during that time.
>
> Some recent comments on [1] seem to indicate that this is somehow coupled
> into prior problems/panics with Intel graphics.
>
> David, was this also your case, or did the EEPROM got garbled out of a
> sudden?

I have no evidence in my logs of a graphics panic, but I do do a lot
of graphics devel,
so it might be a possiblity but I'd hate to handwave it away at that.

Dave.

>
> [1] https://bugzilla.novell.com/show_bug.cgi?id=425480
>
> --
> Jiri Kosina
> SUSE Labs
>
