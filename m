Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZAGAmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZAGAmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbZAGAlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:41:23 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4607 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbZAGAlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:41:21 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=jiyHMCrOl2A9yN2UusQA:9 a=rmhdqi7AOI5CBG-1SdwA:7 a=c6mGYdXK1jiHo1Bpl0A2nOrd4yAA:4
Message-ID: <4963FA2E.2020109@shaw.ca>
Date: Tue, 06 Jan 2009 18:41:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: confusing checkpatch.pl messages
References: <4963C5C0.2080304@freemail.hu>
In-Reply-To: <4963C5C0.2080304@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> Hi,
> 
> I run the checkpatch.pl against the attache file and it reported some
> confusing warning and error messages. The attached file has an obsoleted
> syntax:
> 
> From "info gcc", Chapter 5.21 "Designated Initializers":
>>  In a structure initializer, specify the name of a field to initialize
>> with `.FIELDNAME =' before the element value.  For example, given the
>> following structure,
>>
>>      struct point { int x, y; };
>>
>> the following initialization
>>
>>      struct point p = { .y = yvalue, .x = xvalue };
>>
>> is equivalent to
>>
>>      struct point p = { xvalue, yvalue };
>>
>>  Another syntax which has the same meaning, obsolete since GCC 2.5, is
>> `FIELDNAME:', as shown here:
>>
>>     struct point p = { y: yvalue, x: xvalue };
> 
> However, the checkpatch.pl speaks about labels, which are incorrect, I think:
>> $ /usr/src/linux/scripts/checkpatch.pl --file test.c
>> WARNING: labels should not be indented
>> #5: FILE: test.c:5:
>> +       open: test_open,

Well, the warning message is wrong, that part is presumably a bug. It's 
right to complain, though, as that obsolete syntax shouldn't be used.
