Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZA2Qc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZA2Qc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 11:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbZA2Qcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 11:32:46 -0500
Received: from n6a.bullet.mail.ac4.yahoo.com ([76.13.13.69]:46505 "HELO
	n6a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753678AbZA2Qcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 11:32:43 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 299873.84551.bm@omp101.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=4cB0zxhWULcWxcfTP1q5Rs72Iw+BNaW0Fl1MaG+PHkFvW0qrdhTP5GoJar4/Q7h1VfaPJ0IcB4Kn1f5GrWnyeO52Jf6gPMC8xBK2TSV3w3Fs8XJz6Ve+eBTKlYdFxBvwyhdBK5vrOo2xny33+T7khGhUbPxyqqusRJp3nxHAaw8=;
X-YMail-OSG: HteDT98VM1mXq.jXy2VyR60JRliaEv8kTo8E17BKsZiWELSLT6traC3ZuOUuT.GlL8nym8CTyHYJIBr24SxZPcEh6c2Miy.w6eBw7y5OQ1HNw1nE9LcXNThHA31rXhz83vIZXV95OuaYVYmuTZuiBUiBz9RG3Qp6Z4knrqWbFF1tpTKgRpuqpByk21cP1WFowMlTwOQ-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 29 Jan 2009 08:32:41 -0800 (PST)
From: Xiaoning Ding <dingxn@ymail.com>
Reply-To: dingxn@ymail.com
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090129024539.GA17541@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <213679.55387.qm@web59907.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




--- On Thu, 1/29/09, Dave Jones <davej@redhat.com> wrote:

> From: Dave Jones <davej@redhat.com>
> Subject: Re: a question about p4_clockmod module on Xeon quad core processors
> To: "Xiaoning Ding" <dingxn@ymail.com>
> Cc: linux-kernel@vger.kernel.org
> Date: Thursday, January 29, 2009, 2:45 AM
> [please don't top-post]
> 
> On Wed, Jan 28, 2009 at 06:06:37PM -0800, Xiaoning Ding
> wrote:
>  
>  > >  > I have tried the p4-clockmod module in
> Linux kernel
>  > > 2.6.29 on Xeon 5355 quad-core CPUs with no luck.
> It seems
>  > > current p4-clockmod driver still cannot support
> Intel Quad
>  > > core processors, right? 
>  > >  > 
>  > >  > I know I can also use acpi-cpufreq. It can
> only scale
>  > > down the frequence from 2.67GHz to 2GHz. But I
> need some
>  > > lower frequencies for some experiments.
>  > > 
>  > > p4-clockmod doesn't change the processor
> frequency.
>  > > Because of common misconceptions like this, the
> user
>  > > interface has been removed.
>  > > 
>  > > In 2.6.29, the clock modulation code is called
> directly
>  > > from ACPI
>  > > whenever thermal events indicate that throttling
> is
>  > > necessary.
>  > > 
>  > Thanks for the correction. 
>  > My experiments need to reduce CPU speed. However, I
> can only reduce the speed by about 30% (from 2.67GHz to
> 2GHz) with ACPI. That is not enough for the experiments. 
> 
> The ACPI P-states are nearly always correct, so you
> won't be
> able to go below 2GHz on this system.

That's true for changing P-States with ACPI. But I can still get slower speed with clock modulation, right?
 
>  > p4-clockmod has not been removed from 2.6.29. It is
> under the same directory as acpi-cpufreq
> (arch/x86/kernel/cpu/cpufreq). So I thought it was an
> alternative approach. But I could not get it loaded.
> 
> The driver is present, the _user interface_ has been
> removed.

The module cannot loaded on Xeon 5355. If I can load it, I hope I can find a method to use it.

> 	Dave
> 
> -- 
> http://www.codemonkey.org.uk
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      

