Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbXCTIXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbXCTIXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 04:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbXCTIXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 04:23:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:43428 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbXCTIXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 04:23:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qUa+wURp+RbnzHkGI7BaURJD3WgG/WYE70goIwqSpXyYxNT/Ia6OzIvOWEsFzv+TAocuGf+x6WLvhcfWcgDwXDb6iYeSQePztuRiQr+nH9P2V9cL3dNnb9PmjocSwagXeiAOKeg8wjXum5PE+EUJPYWCPEIjh2WBavI6a8ORXfs=
Message-ID: <b93822910703200123g5b3ac0e4n1ba1122a7e90a838@mail.gmail.com>
Date: Tue, 20 Mar 2007 09:23:48 +0100
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: tglx@linutronix.de
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, "Len Brown" <lenb@kernel.org>,
       "Andi Kleen" <ak@suse.de>, "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <1174353329.13341.762.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
	 <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
	 <1174334646.13341.577.camel@localhost.localdomain>
	 <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com>
	 <1174337777.13341.621.camel@localhost.localdomain>
	 <b93822910703191451o216a8931v9023b174fdef750@mail.gmail.com>
	 <1174353329.13341.762.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/20, Thomas Gleixner <tglx@linutronix.de>:
> On Mon, 2007-03-19 at 22:51 +0100, Stefan Prechtel wrote:
> > 2007/3/19, Thomas Gleixner <tglx@linutronix.de>:
> > > On Mon, 2007-03-19 at 21:35 +0100, Stefan Prechtel wrote:
> > > >            CPU0       CPU1
> > > >  0:      28289          0  local-APIC-edge-fasteio   timer
> > > > ...
> > > > LOC:      28237      28236
> > > >
> > > > after a read: (I hope that is this what you want :-)
> > > >            CPU0       CPU1
> > > >   0:      30344          0  local-APIC-edge-fasteio   timer
> > > > ...
> > > > LOC:      30292      30291
> > >
> > > Is this with AC plugged in ? If yes, please provide the same numbers for
> > > battery mode.
> >
> > Yes. And here is the output for battery mode (2.6.20):
> >            CPU0       CPU1
> >   0:     292153          0  local-APIC-edge-fasteio   timer
> > LOC:     292114     292113
> >
> >            CPU0       CPU1
> >   0:     293263          0  local-APIC-edge-fasteio   timer
> > LOC:     293224     293223
>
> Hmm. Can you please apply the following patch on top of 2.6.20 and
> check, if the WARN_ON_ONCE triggers when you boot w/o AC plugged ?
>
> Thanks,
>
>         tglx

Good morning!

The WARN_ON / WARN_ON_ONCE didn't trigger on boot.

- Stefan Prechtel
