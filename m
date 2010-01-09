Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061Ab0AIVA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0AIVA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 16:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561Ab0AIVA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 16:00:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39517 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0AIVA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 16:00:57 -0500
Message-ID: <4B48EDA6.4050608@zytor.com>
Date: Sat, 09 Jan 2010 12:57:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Arjan van de Ven <arjan@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001090107.43402.arnd@arndb.de> <4B47C984.1080903@zytor.com> <201001090901.37208.arnd@arndb.de>
In-Reply-To: <201001090901.37208.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2010 12:01 AM, Arnd Bergmann wrote:
> On Saturday 09 January 2010, H. Peter Anvin wrote:
>>>       return put_user(data, uptr);
>>>
>>> The latter form requires a macro instead of a function for the user copy,
>>> but we now have that anyway because of the size check.
>>>
>>
>> Well... we already have the latter form?
> 
> Right, but my suggestion was to extend that do data structures in
> addition to the scalars we are supporting now.
> 
> 	Arnd

Structures, as in "struct"?  That would seem to be a good idea.  Arrays,
which can be dynamically sized, are trickier.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

