Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbZAYLtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbZAYLtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZAYLtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:49:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:23208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZAYLtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cHyD5PFhGFOFkqM6zvMrabQk3whYwNzh9Rd9EqVAqw8FZpzKlnSQcgf5QrixZXPb6h
         jlxGIgTpQ7Zo/9A55T30QiFwtFhfIDIQw2Al+58Djlow2P7HKSFhkggHF89IllKE9Brp
         aZ79WM8ffvmDq7GVyqnhdb2TDB3DkiaDArdwY=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901251035050.3424@localhost.localdomain>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
	 <75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com>
	 <alpine.LFD.2.00.0901241716540.3424@localhost.localdomain>
	 <1232845026.3990.71.camel@perihelion.bos.jonmasters.org>
	 <1232849565.29318.112.camel@sven.thebigcorporation.com>
	 <20090125040246.GE9216@mit.edu>
	 <alpine.LFD.2.00.0901251035050.3424@localhost.localdomain>
Date: Sun, 25 Jan 2009 12:49:18 +0100
Message-ID: <195c7a900901250349t6c0cdc73gdbd71a9f87151d72@mail.gmail.com>
Subject: Re: [RT] [RFC] simple SMI detector
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Theodore Tso <tytso@mit.edu>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 10:40 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 24 Jan 2009, Theodore Tso wrote:
>> On Sun, Jan 25, 2009 at 01:12:45PM +1100, Sven-Thorsten Dietrich wrote:
>> I will also note that for some applications (i.e., military hardware
>> running under battle conditions), where it might be that running the
>> hardware beyond its thermal limits might actually be *desirable*.
>> After all, an extra 15 minutes of running beyond thermal limits that
>> eventually causes the CPU to get flakey might be worth it if the
>> alternative is the ship getting sunk because the BIOS decided that
>> shutting down the CPU to save it from thermal damage was more
>> important than say, running the anti-aircraft guns....
>
> In that case the system designer knows exactly what he is doing and he
> is aware of the consequences.
>
> My concern about the SMI disable module is that it can damage Joe
> users hardware. I have at least two reports where the CPU got fried
> and some others where people got confused because chips started
> behaving weird and it took quite a time to figure out that they used
> the SMI disabler. A big fat warning about this code is definitely
> necessary.
>
> Thanks,


I suppose the non joe user could flash their motherboard with
linuxcore and therefore do not distrub by SMI :)

Regards

Bastien
