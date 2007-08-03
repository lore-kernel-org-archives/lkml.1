Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbXHCFAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbXHCFAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 01:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXHCFAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 01:00:37 -0400
Received: from [202.78.101.198] ([202.78.101.198]:38537 "EHLO mx1.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752164AbXHCFAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 01:00:36 -0400
Message-ID: <46B2B684.2000207@gmail.com>
Date: Fri, 03 Aug 2007 13:00:52 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B2578A.805@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030024490.6774@poirot.grange> <20070802155434.b085219c.rdunlap@xenotime.net> <Pine.LNX.4.60.0708030056390.6774@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708030056390.6774@poirot.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> On Thu, 2 Aug 2007, Randy Dunlap wrote:
> 
>> C99 spec that Al referred you to (available for around US$18 as a pdf)
>> says in 6.7.8, para. 14 (where Al said):
>>
>> "An array of character type may be initialized by a character string literal, optionally
>> enclosed in braces. Successive characters of the character string literal (including the
>> terminating null character if there is room or if the array is of unknown size) initialize the
>> elements of the array."
> 
> Wow... So, the terminating '\0' in the string constant IS "special" and 
> "optional"... Ok, then, THIS does answer my question, THIS I can 
> understand, and, ghm, accept...
> 
> Thanks to all who tried to explain this to me and sorry it took so long...

You should not have asked in the first place.  The declaration

char c[4] = "abcd"

is perfectly valid. There is no cause for debate about it :)

Thank you very much.

Best Regards,

Carlo

-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, UP Campus Diliman
1101 Quezon City, Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
