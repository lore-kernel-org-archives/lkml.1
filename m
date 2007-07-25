Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbXGYFnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbXGYFnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXGYFnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:43:15 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:23718 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751512AbXGYFnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:43:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5eOb0yEdTbzv1mCbmrL+IY2G7rdkz7oznXzStDfGCTOE2qzMzGo/VHCQaNAZgPTgHyG3w6+NAc7hA069AQxMsyjCBNxqtX4QA7yxaTmzhRXOkNZ6F2foltYPRYzIJNNOIMxeZtwsxuCyt3EVOF/D6ygmZqRU/S5TDmbXhybNkUw=  ;
X-YMail-OSG: lpmCvSsVM1mo194_EoBDCy2zl_wTyfVx2kEv2jWAF_R8FBXi
Message-ID: <46A6E2EE.4040207@yahoo.com.au>
Date: Wed, 25 Jul 2007 15:43:10 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear
 mappings
References: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>	 <46A6C72A.9020801@yahoo.com.au> <21d7e9970707242137x51ca8a64wadfb06c7b543af38@mail.gmail.com>
In-Reply-To: <21d7e9970707242137x51ca8a64wadfb06c7b543af38@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>>
>> Is this with a binary-only module? We saw an issue with that in SLES9
>> where the module is returning a locked page from its nopage handler
>> when it isn't really supposed to. It might be fixed in latest drivers,
>> have you tried them?
> 
> 
> Doesn't sound like it he mentions radeon drm module which is open...

OK. Well from the task trace, X is getting stuck on a locked page. And
as it is never getting unlocked, I'd be almost positive it comes from
a driver's nopage. I know some ATI driver did that in the past. Would
the radeon drm module do anything similar?

-- 
SUSE Labs, Novell Inc.
