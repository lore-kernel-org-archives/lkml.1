Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYIAJXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYIAJXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbYIAJXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:23:15 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:41890 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbYIAJXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:23:14 -0400
Message-ID: <48BBB480.3000907@dgreaves.com>
Date: Mon, 01 Sep 2008 10:23:12 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11460] 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>	<N8SeMoDzuxC.A.-VD.xhbuIB@albercik>	<48B9C7C6.2060209@dgreaves.com> <18619.22913.1452.426243@notabene.brown>
In-Reply-To: <18619.22913.1452.426243@notabene.brown>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Saturday August 30, david@dgreaves.com wrote:
>> Rafael J. Wysocki wrote:
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.26.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11460
>>> Subject		: 2.6.27-rc3 to -rc4 regression: init 0 hangs in halt
>>> Submitter	: David Greaves <david@dgreaves.com>
>>> Date		: 2008-08-30 04:07 (1 days old)
>> Yes.
>>
>> I'm trying to bisect it but came across a bug/problem in git doing bisects.
>> (see message subject "setlocalversion wasn't producing git labels for bisect")
> 
> Hi David.
> 
> Could you please try this patch?

Yes, that fixed it.

Thanks

David

