Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYKCORx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYKCORx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYKCORm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:17:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:42167 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbYKCORl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:17:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:newsgroups:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from
         :sender;
        b=l1Jmou+zBzrhw4GI3OJyM7vTlyswfrIjU0c8alQ4pYsi4ZQwOHbXcKSPewSGyT9Gw0
         T07bRmKi6ejBY89hITKbz3eerhLeqWdPmrstcftdP4dJMbgr1mUqt6E52Q7RlJeMyS2+
         v4U+cgjyFFdYRwo9zm+CwjrzxHR2B8yPdX3Rk=
Message-ID: <490F07F8.10403@tuffmail.co.uk>
Date: Mon, 03 Nov 2008 14:17:28 +0000
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
Newsgroups: gmane.linux.acpi.devel,gmane.linux.kernel
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Robert Hancock <hancockr@shaw.ca>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "fabio.comolli@gmail.com" <fabio.comolli@gmail.com>
Subject: Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>	 <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no> <49035313.9080309@shaw.ca>	 <200810252004.01274.rjw@sisk.pl>	 <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>	 <8db1092f0810271319s5d15c2ffrab37a548fa388738@mail.gmail.com>	 <1225187050.5189.146.camel@yakui_zhao.sh.intel.com>	 <8db1092f0810281245k14555e26w30547cf17fde534f@mail.gmail.com> <8db1092f0811030406i48150022gb5b444710d749b43@mail.gmail.com> <490EEDDD.4010203@gmail.com>
In-Reply-To: <490EEDDD.4010203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Maciej Rutecki wrote:
>> Problem still exists on 2.6.28-rc3:
>> ACPI: EC: missing confirmations, switch off interrupt mode.
>> ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for
>> [EmbeddedControl] [20080926]
>> ACPI Error (psparse-0524): Method parse/execution failed [\_TZ_.C31E]
>> (Node f7019858), AE_TIME
>> ACPI Error (psparse-0524): Method parse/execution failed
>> [\_TZ_.TZ3_._TMP] (Node f7019ed0), AE_TIME
>>
>> But I don't see any functional problems.
>>
>> Regards
>>   
> please see #11917

Um, I think you mean #11896.  I confess I don't understand why they are considered duplicates of each other, they have different error messages and patches.

Maciej: if you look at #11896, you will find patches from two different people.  If you're interested... well, let's just say I suggest you try Alex's patch first :).

Alan
