Return-Path: <linux-kernel-owner+w=401wt.eu-S966854AbXEGVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966854AbXEGVe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966833AbXEGVex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:34:53 -0400
Received: from kirby.webscope.com ([204.141.84.54]:52725 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966827AbXEGVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:34:52 -0400
Message-ID: <463F9B4F.7020708@linuxtv.org>
Date: Mon, 07 May 2007 17:34:07 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>		<46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>		<4638C046.1020005@gmail.com> <20070503112013.272380@gmx.net>		<4639F554.1040505@gmail.com> <20070503153129.268110@gmx.net>		<463A0462.5070106@gmail.com>		<d9def9db0705030859y66b1ef8fv22fc844c77bcc3c6@mail.gmail.com>		<463A0B36.5080204@gmail.com>		<d9def9db0705031019l5083d1c1h607b0829ab526f1@mail.gmail.com>		<1178215045.12651.124.camel@localhost> <463A31EE.20907@gmail.com>		<1178388401.12541.115.camel@localhost> <463CD106.3000706@gmail.com>	<1178571269.18383.296.camel@localhost> <463F9941.1060303@gmail.com>
In-Reply-To: <463F9941.1060303@gmail.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manu Abraham wrote:
> Mauro Carvalho Chehab wrote:
>> Hi Manu,
>>
>>> From my side, quite some time has been put forward to write that mail.
>>> Inspite of that if you feel that you do have to go your own way, then
>>> it is completely upto you. I would say: do as you feel in such a case.
>> The point is that those issues are pending for a long time, and they
>> should be solved, especially the module removal issue (*)
>>
>> If you are so afraid about applying those changes, maybe the better is
>> to apply those patches at v4l-dvb tree and at -mm, asking people to
>> test.
>>
>> We may hold their commit on kernel mainstream until the next kernel
>> release, if nobody complains about, or otherwise revert the changes, if
>> they proofed to cause troubles at dst and/or dvb-bt8xx.
>>
>> Also, you (or others) may write another approach keeping the fixes with
>> an strategy more adequate for dst.
>>
>> Do you agree with this way?
> 
> NACK
> 
>> -- 
>> Cheers,
>> Mauro
>>
>> (*) Currently, dst can be removed only with "rmmod -f", due to a wrong
>> usage count. With Trent's patches, this were fixed.
> 
> http://article.gmane.org/gmane.linux.drivers.dvb/27792/match=re+linux+dvb+unable+rmmod+dst+bt8xx

Just to make things clear, Manu, Are you telling us that the patch in the above
link addresses the use count bug?

If that is the case, are you suggesting that that patch be applied to the
repository instead of Trent's changesets?

Moreso, if that is the case, then the patch in the above link lacks a
sign-off...  We need to apply SOMETHING to fix this problem, and you know the
rules...

What should be done to fix the use count bug?

Regards,

Michael Krufky

