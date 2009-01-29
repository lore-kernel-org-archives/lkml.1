Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZA2Tkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZA2Tkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZA2Tk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:40:27 -0500
Received: from n1b.bullet.mail.ac4.yahoo.com ([76.13.13.71]:21657 "HELO
	n1b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752507AbZA2Tk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:40:26 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 449436.99435.bm@omp119.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ymail.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=wC+xHx2Wp2sqTw3jCMTp8MIeEsXI4fNXWM9y7doP9OdVGo0plktAeBzBXEq1aptG6qHqsGaJNhyXEXsFbOBikQLNHXRJYrtkxGG7Ku7pmLbzl9xzmqDJ5wmSVyGoB/V8fWUHUwCcqHiUkH10VbAW4Mw/B+MES6nWOv+YgFbOTy4=;
X-YMail-OSG: u1SgbJIVM1m8A.bVr8qT89Mw.l0gDRm.FqRB2wU9krB3ul9wkfp0yNKIItJpnXAZy6puIh.gOOLbIVFne36FKIgAsatG8ar9SiF8ahdaW9v1t9jUvU0veclv41kuJFrrnK8EcWMD0rgN.Q9.eLAblFfwiszAW956MF96GctxAJ2j0oqen0N2IfbbXz_g0pu71m0fJUpMR2udpsiVhXowfGRqWIIzRe8SHONFojXR
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 29 Jan 2009 11:40:25 -0800 (PST)
From: Xiaoning Ding <dingxn@ymail.com>
Reply-To: dingxn@ymail.com
Subject: Re: a question about p4_clockmod module on Xeon quad core processors
To: Michael Tokarev <mjt@tls.msk.ru>, Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090129172406.GB14096@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <279321.76517.qm@web59906.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 1/29/09, Dave Jones <davej@redhat.com> wrote:

> From: Dave Jones <davej@redhat.com>
> Subject: Re: a question about p4_clockmod module on Xeon quad core processors
> To: "Michael Tokarev" <mjt@tls.msk.ru>
> Cc: "Xiaoning Ding" <dingxn@ymail.com>, linux-kernel@vger.kernel.org
> Date: Thursday, January 29, 2009, 5:24 PM
> On Thu, Jan 29, 2009 at 03:27:24PM +0300, Michael Tokarev
> wrote:
> 
>  > > p4-clockmod doesn't change the processor
> frequency.
>  > 
>  > Hmm..  But what it really does, then?
> 
> it modulates the clock so the CPU isn't always availble
> for doing work.
> 
>  > I used it one one machine which had a flaky CPU
> cooler,
>  > to reduce power consumption during hot summer days.
> 
> it reduces the amount of heat generated, by making jobs
> take longer to finish. This comes at a cost of the CPU not
> being able to enter lower C states for longer periods of
> time,
> so you may end up actually using *more* power.
> 
>  > It worked, and reportedly the frequency varied from
>  > 200MHz to the max of 2.4GHz (it's a P4 Xeon).
> 
> The CPU was always at 2.4GHz, even if it said
> '200MHz'.
> It was just only doing work once in every 12 clocks.
> 
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

Thanks for the explanation. So the conclusion is that ACPI-cpufreq can reduce power consumption by lowering cpu frequencies, and p4-clockmod can hardly save power because CPU frequences are not changed.

My experiments do not consider power consumption. It only requires to slow down the speed of some cores by either reducing frequencies or clock modulation. In such case, p4-clockmod is still a good choice for me. Can anyone give me some hints on whether p4-clockmod works on Xeon quad-core processors, and how to get it work?

Thanks!

Xiaoning


      

