Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZGHWsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZGHWsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbZGHWs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:48:29 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35934 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbZGHWs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dFtAy/W0nf3ObA25fu0SajbC53mtNf19ua/mh2f1q4gSERsmkSATdAWtHpEl8Uxi+l
         12kCQAVcPZ7niragIMhqPDPyxKQwyzoBqBXKJlZoVBqQOnAjM8j7MX4fEFVWPqIBqaPu
         HT/hZ8aiGZE+/GtIbsaR0sHIrWMMRehDaR3EY=
MIME-Version: 1.0
In-Reply-To: <20090708224259.GC3666@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <200907071811.27570.andres@anarazel.de> 
	<20090708080852.GC3148@ami.dom.local> <200907081029.34527.andres@anarazel.de> 
	<20090708091344.GD3148@ami.dom.local> <a5d9929e0907081444r4a1e0828taf538c686577f09c@mail.gmail.com> 
	<20090708220749.GA3666@ami.dom.local> <a5d9929e0907081527n38a4c369k5b886520b7cc0229@mail.gmail.com> 
	<20090708224259.GC3666@ami.dom.local>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Wed, 8 Jul 2009 23:48:06 +0100
Message-ID: <a5d9929e0907081548r2b07bd5dk612529532c61a13f@mail.gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( 
	possibly?caused by netem)
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andres Freund <andres@anarazel.de>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> (this time i triple-checked :-) )
>>
>> So, with only this last patch applied, no freeze. No need to disable
>> anything through /proc.
>>
>> Where should i put the BUG_ON?
>
> Hmm... Not so fast! I've looked in timers till now; "tomorrow" I'll
> "change resolution". ;-)
>
> Thanks again,
> Jarek P.
>

Of course :-)

Thanks for looking into this.
Joao Correia
