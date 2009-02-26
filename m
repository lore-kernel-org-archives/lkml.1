Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858AbZBZTi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbZBZTi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZBZTir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:38:47 -0500
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:42050 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752836AbZBZTir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:38:47 -0500
X-Yahoo-Newman-Id: 705981.70303.bm@omp421.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rgJPLfG9ra5XNNheKqwdMqiFBroN3R9YAdbiz12+t89qR/9X3b3mm/I6sqOzve1wzDt6+UFL145YUgChDy5gxOVLILIai+YduA9SgkVLhUDnocPj7M9FHuKwek05Rhsq+Vd7ybwzI3u7hFNUfODxerGRw1SYbSgjRhoOxS3cJI0=  ;
X-YMail-OSG: Ym9ymnkVM1m97JLAP19Vtv.r.zZxRBPgTAoEpdpChg7raeleRAUheok9175Q.1GZH33bgEWAluJ9h19Zc6XyuvRn1WHHXAZp6_Il7exUHC4v8O0CJYNY2DgnKLdF9VwsZzzLELVChw8NOUUrddfKlXOC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch/rfc 2.6.29-rc6 1/2] regulator: enumerate voltages
Date: Thu, 26 Feb 2009 11:38:34 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261056.05740.david-b@pacbell.net> <20090226190511.GD8595@sirena.org.uk>
In-Reply-To: <20090226190511.GD8595@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261138.34859.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Mark Brown wrote:
> On Thu, Feb 26, 2009 at 10:56:05AM -0800, David Brownell wrote:
> > On Thursday 26 February 2009, Mark Brown wrote:
> 
> > > Unless, of course, you happen to be using one of those consumers that
> > > wants to know the voltage it's running at to configure itself.
> 
> > In which case it can ask the regulator what voltage it's using.  :)
> 
> I suspect we're talking at cross purposes here - I was talking about the
> fixed voltage regulator driver.  I suspect you were talking about
> something else?

Yes ... e.g. the USB1V5, USB1V, and USB3V1 regulators
exported through the twl4030 regulator driver.


Semi-related:  someone with time to spend on it might
find and fix the bug causing the regulator framework
to oops when regulator/core.c::set_machine_constraints()
returns an error code.

- Dave

