Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbZGVL2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbZGVL2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZGVL2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:28:03 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:37747 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZGVL2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:28:02 -0400
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2009 07:28:01 EDT
Date: Wed, 22 Jul 2009 12:54:27 +0200 (CEST)
From: Krzysztof Oledzki <oley@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Jens Rosenboom <jens@leia.mcbone.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Troy Moure <twmoure@szypr.net>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <1248256689.7237.2.camel@fnki-nb00130>
Message-ID: <alpine.LNX.1.10.0907221252230.26357@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl>  <20090720151008.GC10015@suse.de>  <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>  <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>  <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
  <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl>  <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl>  <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>  <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain> 
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop>  <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>  <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain>  <alpine.LNX.1.10.0907220914150.26357@bizon.gios.gov.pl> 
 <alpine.LNX.1.10.0907221022380.26357@bizon.gios.gov.pl> <1248256689.7237.2.camel@fnki-nb00130>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1430614368-1248260067=:26357"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1430614368-1248260067=:26357
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Wed, 22 Jul 2009, Jens Rosenboom wrote:

> On Wed, 2009-07-22 at 10:32 +0200, Krzysztof Oledzki wrote:
>>
>> On Wed, 22 Jul 2009, Krzysztof Oledzki wrote:
>>
>>>
>>>
>>> On Tue, 21 Jul 2009, Linus Torvalds wrote:
>>>
>>>>
>>>>
>>>> On Tue, 21 Jul 2009, Linus Torvalds wrote:
>>>>>
>>>>> Anyway, I bet we can work around the compiler bug by just changing the
>>>>> type of "i" from "unsigned char" to be a plain "int".
>>>>
>>>> IOW, like this.
>>>>
>>>> 		Linus
>>>>
>>>> ---
>>>> drivers/video/fbmon.c |    4 ++--
>>>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
>>>> index 5c1a2c0..af4a15c 100644
>>>> --- a/drivers/video/fbmon.c
>>>> +++ b/drivers/video/fbmon.c
>>>> @@ -256,8 +256,8 @@ static void fix_edid(unsigned char *edid, int fix)
>>>>
>>>> static int edid_checksum(unsigned char *edid)
>>>> {
>>>> -	unsigned char i, csum = 0, all_null = 0;
>>>> -	int err = 0, fix = check_edid(edid);
>>>> +	unsigned csum = 0, all_null = 0;
>
> I guess Linus shouldn't have deleted the "char" here...

Yep! However, it took me one more hour to find it. I should have read my 
mails more often. ;)

Thanks.

Best regards,

 			Krzysztof Olêdzki
---1144830174-1430614368-1248260067=:26357--
