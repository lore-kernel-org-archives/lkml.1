Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXCSUfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXCSUfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXCSUfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:35:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:2634 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbXCSUfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IPFu87mn9F/AjX5zGZJpILsCxSjl0cLcLnHZgDyZ6MXn3s5Z0ArnVsbgkBeO48e5QZyMRIbEepwG7IkvJm2UWLc4eU5EJElldzk73XkvwiEPk0YU+kuVyb3gM1CMyErlLGZoylEJ1OsGjr+ZlYLQEnkk29fIdpWycTXNrXk09aY=
Message-ID: <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com>
Date: Mon, 19 Mar 2007 21:35:48 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, "Len Brown" <lenb@kernel.org>,
       "Andi Kleen" <ak@suse.de>, "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <1174334646.13341.577.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
	 <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
	 <1174334646.13341.577.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/19, Thomas Gleixner <tglx@linutronix.de>:
> > Here is the output of /proc/interrupts on 2.6.20:
> >            CPU0       CPU1
> >   0:       7089          0  local-APIC-edge-fasteio   timer
> > ....
>
> Can you provide the numbers for LOC too ?
>   0:   29801420   29793520    IO-APIC-edge  timer
> ...
> LOC:  119180305  119180039
>
> And please do a sleep 10; between two reads, so I can see the deltas.

Ah sorry. I forgot it..
           CPU0       CPU1
 0:      28289          0  local-APIC-edge-fasteio   timer
...
LOC:      28237      28236

after a read: (I hope that is this what you want :-)
           CPU0       CPU1
  0:      30344          0  local-APIC-edge-fasteio   timer
...
LOC:      30292      30291


- Stefan Prechtel
