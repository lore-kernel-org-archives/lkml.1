Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409AbZHZPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbZHZPGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZHZPGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:06:22 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49368 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZHZPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:06:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OcAEgQkKOEp1mCrQySpOUlefDFeD8ZuEfNp8a2NXKkYmyAUODfez9D7ZTHMPi2zTqO
         /SF88HKtNtkFO/v+cM6ORuZpn5Za819iqvr8JTBU/y61xCGc9EEBZizHaiRy8aiESEth
         awUymY3kf8h1GsiytEEho9tlvZdeULkex4uWY=
MIME-Version: 1.0
In-Reply-To: <1251298443.4791.7.camel@raz>
References: <1250983671.5688.21.camel@raz>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
	 <1251227322.7538.1172.camel@twins> <4A943A00.9080609@nortel.com>
	 <1251264700.7538.1178.camel@twins> <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>
Date: Wed, 26 Aug 2009 18:06:21 +0300
X-Google-Sender-Auth: 4a4bac8d4668a8d1
Message-ID: <84144f020908260806pb85ee72r7b7e32a07b921b59@mail.gmail.com>
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: raz ben yehuda <raziebe@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 5:54 PM, raz ben yehuda<raziebe@gmail.com> wrote:
>> I have always been fascinated by the idea of controlling another cpu
>> from the main CPU.
>>
>> Usually these cpus are custom, run proprietary software, and have no
>> datasheet on their I/O interfaces.
>>
>> But, being able to turn an ordinary CPU into something like that seems
>> to be very nice.
>>
>> For example, It might help with profiling. Think about a program that
>> can run uninterrupted how much it wants.
>>
>> I might even be better, if the dedicated CPU would use a predefined
>> reserved memory range (I wish there was a way to actually lock it to
>> that range)
>>
>> On the other hand, I could see this as a jump platform for more
>> proprietary code, something like that: we use linux in out server
>> platform, but out "insert buzzword here" network stack pro+ can handle
>> 100% more load that linux does, and it runs on a dedicated core....
>>
>> In the other words, we might see 'firmwares' that take an entire cpu for
>> their usage.
>
> This is exactly what offsched (sos) is. you got it. SOS was partly inspired by the notion of a GPU.

So where are the patches? The URL in the original post returns 404...
