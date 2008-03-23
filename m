Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbYCWMtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbYCWMtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 08:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbYCWMtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 08:49:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:9474 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYCWMtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 08:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UZCwWnU9eOCWBaemCJgELx0tfmd4Pn9pLFQbb7HNr4+HEceoH4xIGAxxnztLPQMwVAtKJ7eE1tfyhHqK1Pcsp3SvuLSdGR1diCMXWy+o1kkIpiwJj8N3sqmtiFKQvkwzwf6Eg01dmXgyLIGhHFWuyZyQk2zdkm2r66vG9hnBlSA=
Message-ID: <47E651BE.1080107@gmail.com>
Date: Sun, 23 Mar 2008 13:49:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: viro@ZenIV.linux.org.uk, joe@perches.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: checkpatch [was: include/asm-x86/serial.h: checkpatch cleanups -
 formatting only]
References: <47E647AC.1060906@gmail.com>	<20080323.051929.267232495.davem@davemloft.net>	<47E64BF7.4070808@gmail.com> <20080323.053037.144236584.davem@davemloft.net>
In-Reply-To: <20080323.053037.144236584.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2008 01:30 PM, David Miller wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Sun, 23 Mar 2008 13:24:23 +0100
> 
>> On 03/23/2008 01:19 PM, David Miller wrote:
>>> There are mountains of more useful stuff to be working on (much of it
>>> automated, but unlike checkpatch work doesn't result in crap) rather
>>> than 148 patches of checkpatch vomit.
>>>
>>> Fixing sparse warnings properly fixes real issues, whereas fixing
>>> checkpatch stuff creates garbage 9 times out of 10.
>> Yes, I agree with you in this.
>>
>> What I don't agree with is that it's useless. It may help track down some issues 
>> in yet prepared patch (it's checkpatch, not checkcode and it should be used in 
>> that manner).
> 
> I strongly disagree still.
> 
> Half the warnings I get when I have run checkpatch on things I've
> written were crap.

Could you be more concrete here? I often get only "more than 80 columns used 
blah blah" in the header files and this sucks, yes. This check removal was 
discussed some time ago on the list, seems like the result was to let it be.

> It's an automaton, and that's why people like it.  It tells you
> exactly what to do, and people like to be able to turn their brains
> off like that.

It just spits out warnings/errors like compiler or some static analyzer, maybe 
I'm terribly missing something, what exactly do you mind on the output?
