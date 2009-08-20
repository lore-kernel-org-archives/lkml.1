Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZHTNbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZHTNbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZHTNbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:31:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:43535 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099AbZHTNbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:31:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=IjALwMjwt21LonVOdfqcSPy8l4XFj1K2Fdg/l3nb1CiAhAPqvoHXaO5Ny3oefkNowh
         jRFG1HCiMVGYoM2CHVbNdS2VaD8s95XmbD/gUYUr83OnDaZKWDdLM629mjyaBRVQJmlP
         45adZZvqbZpZE1fFZXV4hiRpO/KXwUN2StA1U=
From: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
Organization: FreeIT
To: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
Date: Thu, 20 Aug 2009 10:31:00 -0300
User-Agent: KMail/1.12.0 (Linux/2.6.28-13-generic; KDE/4.3.0; x86_64; ; )
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com> <d12c1890908191446k5497d9c8t2f355074eb7ca4ff@mail.gmail.com> <m1k50zi4is.fsf@fess.ebiederm.org>
In-Reply-To: <m1k50zi4is.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908201031.00256.lfpg.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Answers below...

Em Quarta-feira 19 Agosto 2009, às 23:48:59, Eric W. Biederman escreveu:
> Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com> writes:
> 
> > I have changed my distro to sidux, so it won't be an easy task to
> > return to 2.6.24....
> > Anyway, I do use the 64bit kernel.
> 
> > But I've downloaded the 32 bit version (sidux 2009.02 with the
> > 2.6.30.1 kernel), and the very same error occurs. I've just used the
> > live cd, and it does happen.
> 
> Sure.  I inferred this by how early this message starting showing
> up.   This code did not get added into the 32bit kernels until
> recently.
> 
> > Something that changed from 2.6.28 to 2.6.30 is that it no longer
> > happens the 0.99 message. All complaints are about 0.91...
> 
> Interesting.
> 
> > One more thing: Deleting /usr/sbin/irqbalance changed nothing, which
> > is no surprise, as I had already tested the noirqbalance kernel
> > option....
> 
> Even after a reboot?
Yes, even after a reboot.

> 
> Are you running any kind of vitalization on your box?
No.

> 
> > I'm pasting here something I had previously replied personally to
> > Robert Hancock, and may be useful:
> >
> > Well, as I've installed sidux, it has upgraded the kernel to 2.6.30.5,
> > but the error is the same.
> > I've also tried:
> > * noapic: the message changes to do_IRQ: 0.55 No irq handler for
> > vector (irq -1), but then the X server fails to start
> 
> Interesting... 
> 
> > * noacpi: have no effect on the error message.
> 
> There is something very strange about your box.  Possibly it is
> just VIA interrupt controller madness.  VIA has been known
> to interrupt interrupt related fields in creative ways, and
> we may be on the edge of another of these.
Probably. My mother board is an Asus P5VD2-X, which is based on VIA PT890:
http://br.asus.com/products.aspx?l1=3&l2=11&l3=346&l4=0&model=1362&modelmenu=1 (sorry, link in portuguese)

> 
> I expect it is going to come down to writing a patch to dump out
> all of the interrupt routing state on the system and to see what
> is generating the totally unexpected interrupt and then to work our
> way backwards from there.
> 
> The fact that the vector number is changing indicates that it is
> a programmable something that is causing the problem.
> 
> I'm drawing a blank on which patch to write up.
> 
> Eric
> 
Thanks again.

--
Luis Fernando Planella Gonzalez
