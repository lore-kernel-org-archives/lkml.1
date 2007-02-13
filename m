Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbXBMKym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbXBMKym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXBMKym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:54:42 -0500
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:41301 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751268AbXBMKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:54:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ejOh36HmlT18gvG/TlJXU+yOxmufqBOGDDuIK08k0ekzDoC/uO4vd2N5ryo1MVd+Qkpv/u4r3+q2HITZ54IA5RM86GEcfTOkgHX768OS2JWfuERmAaeiiEHzhZTZoZRp3PK90tVoYwTDxeZ4TwTATwebibZn00G/Uka/th5+MfQ=  ;
X-YMail-OSG: r4bCJW0VM1n7wzPueUF7MKfCitwbVMEDocA3Fu84tRiY39x.zpzE.ezo3P_pqU.DB0dzHWI1_kN6cf1b1UfFVMr4NGz.9n6LLtQu0F6oCLkru4FsJGeJvQgCF_JjQTWKvtExyOEj0mAQb58-
Message-ID: <45D198DB.3040006@yahoo.com.au>
Date: Tue, 13 Feb 2007 21:54:19 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: Joe Perches <joe@perches.com>, Ben Nizette <ben.nizette@iinet.net.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)"
 to "array_for_each(index, array)"
References: <1171324070.1528.25.camel@localhost>	 <45D10460.6000903@iinet.net.au> <1171327648.1528.30.camel@localhost>	 <45D13C34.2040400@yahoo.com.au> <1171352052.1528.48.camel@localhost>	 <45D16BF8.9090409@yahoo.com.au> <1171362988.21261.12.camel@tara.firmix.at>
In-Reply-To: <1171362988.21261.12.camel@tara.firmix.at>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> On Tue, 2007-02-13 at 18:42 +1100, Nick Piggin wrote:
> 
>>Joe Perches wrote:
> 
> [...]
> 
>>>perhaps:
>>>
>>>#define array_for_each(element, array) \
>>>	for ((element) = (array); \
>>>	     (element) < ((array) + ARRAY_SIZE((array))); \
>>>	     (element)++)
>>
>>If you're going for consistency, then shouldn't this be
>>array_for_each_entry()?
> 
> 
> That depends on the decision between consistency to array_for_each_index
> or consistency to list_for_each.

I don't follow.

list_for_each gives you a list_head.
list_for_each_entry gives you a pointer to an entry in the list, which
is equivalent to the above loop which gives a pointer to an entry in the
array. Accordingly, it should be called array_for_each_entry. What sort
of logic leads to another conclusion?

array_for_each_index gives an index into the array.

I offer no opinion on the merit of such macros, just their names.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
