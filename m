Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYE1E7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYE1E7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 00:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYE1E7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 00:59:44 -0400
Received: from smtp.nokia.com ([192.100.122.230]:19448 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbYE1E7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 00:59:38 -0400
Message-ID: <483CE625.7090805@yandex.ru>
Date: Wed, 28 May 2008 07:57:09 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 3 29/29] UBIFS: include FS to compilation
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com> <1211810743-18936-30-git-send-email-Artem.Bityutskiy@nokia.com> <20080527220516.GD11310@cs181133002.pp.htv.fi>
In-Reply-To: <20080527220516.GD11310@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 May 2008 04:58:35.0537 (UTC) FILETIME=[7C17C010:01C8C07F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, May 26, 2008 at 05:05:43PM +0300, Artem Bityutskiy wrote:
>> ...
>> --- /dev/null
>> +++ b/fs/ubifs/Kconfig
>> @@ -0,0 +1,71 @@
>> +config UBIFS_FS
>> +	tristate "UBIFS file system support"
>> +	select CRC16
>> +	select CRC32
>> +	depends on MTD_UBI
>> +	help
>> +	  UBIFS is a file system for flash devices which works on top of UBI.
>> ...
...
> 
> Please change this and similar other options to:
> 
> config UBIFS_FS
> 	tristate "UBIFS file system support"
> 	select CRC16
> 	select CRC32
> 	select CRYPTO if UBIFS_FS_LZO
> 	select CRYPTO_LZO if UBIFS_FS_LZO
> 	depends on MTD_UBI
...
> This way UBIFS_FS=m, UBIFS_FS_LZO=y will only force CRYPTO_LZO=m and not 
> CRYPTO_LZO=y.

Ok, thanks for suggestion. Will be done.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
