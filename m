Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZHZIRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZHZIRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 04:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZHZIRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 04:17:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57314 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZHZIRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 04:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jR/7VUdnMxpGBukIX4vN75hfXnHUXbmcO/+5gyynBoJBoUC+QFOoRnVrSNJUCfy+We
         nWq7HrYjZaKlKxTOvjaKxLHkHeHOO1Cjawhei2TQazXhMAChkzWy2vL7sb65x4MWVj20
         vaTNMkqvL4lhTEw/8xrr1yDblRjJcbWg60iNM=
MIME-Version: 1.0
In-Reply-To: <1251273755.16910.16.camel@marge.simson.net>
References: <1250983671.5688.21.camel@raz> <1251021133.14003.172.camel@marge.simson.net> 
	<alpine.DEB.1.10.0908251122020.26329@gentwo.org> <1251222993.7023.53.camel@marge.simson.net> 
	<alpine.DEB.1.10.0908251402300.17963@gentwo.org> <1251227322.7538.1172.camel@twins> 
	<4A943A00.9080609@nortel.com> <1251264700.7538.1178.camel@twins> 
	<1251282598.3514.20.camel@raz> <1251273755.16910.16.camel@marge.simson.net>
From: Raz <raziebe@gmail.com>
Date: Wed, 26 Aug 2009 10:16:59 +0200
Message-ID: <5d96567b0908260116w2e1bcffeqb67f92d89b34b2c@mail.gmail.com>
Subject: Re: RFC: THE OFFLINE SCHEDULER
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Chris Friesen <cfriesen@nortel.com>,
       Christoph Lameter <cl@linux-foundation.org>, riel@redhat.com,
       mingo@elte.hu, andrew motron <akpm@linux-foundation.org>,
       wiseman@macs.biu.ac.il, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:02 AM, Mike Galbraith<efault@gmx.de> wrote:
> On Wed, 2009-08-26 at 13:29 +0300, raz ben yehuda wrote:
>
>> OFFSCHED is bad name to my project. My project is called SOS = Service
>> Oriented System.
>> SOS, has nothing to do with Real time.
>
> ??
>
> The paper you pointed me at maintains it's very much about realtime.
>
> <quote>
> This paper argues that OFFSCHED fits to the niche of Multiprocessors
> real time systems by partitioning a system to two; the operating system
> and OFFSCHED. OFFSHCED is a hybrid system. It is hybrid because it is
> both real time and still a regular Linux server. Real time is mainly
> achieved by the NMI characteristic and the CPU isolation. It is a hybrid
> system because OFFSCHED scheduler interacts with the operating system.
> </quote>
>
>        -Mike.
>
>
Mike Hello
Correct. OFFSCHED has a real time facet that puts it in the SMP real
time system arena. it has other facets such as security and
monitoring. If you take a look at OFFSCHED-RTOP and OFFSCHED-SECURED
you will see that I can actually get information and change a system
properties  (very pool implementation so far, i am a bit tired...)
even if this kernel is not **accessible**.

Raz
