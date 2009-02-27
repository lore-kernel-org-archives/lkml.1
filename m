Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbZB0AMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbZB0AMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZB0AMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:12:09 -0500
Received: from n9b.bullet.sp1.yahoo.com ([69.147.64.101]:34478 "HELO
	n9b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754988AbZB0AMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:12:08 -0500
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Id: 988099.74047.bm@omp405.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Mm6QeweE+MMPelNzyBByzUvkiaTZfSV4IeafZSOwZroDvuW7D5vq9At9UFwlvi9AH7/K65E/28H9QZlXYGeGbWkRWeArgLQRzToMzivGgZ8eXvl6Xp3gpc7pTX6B6Odr4MTNBaRaenFaTlHDLZcDtF3+kS8QNy2oiI0+Q7psETw=  ;
X-YMail-OSG: lPdI.9AVM1njh0ucgxdzuCmKqf_x7iMM0KT1WQ35OQ0eV5jhZeAS7V0AA4UXjqmsmL.oGgl4c3gblq63xyIp0AZv5Qiy5N2jey3KbRiE.psQyr_a63uxw6eTPngXEcdUSKSl0cQG7wrYFBs8.mYsQ5Lt
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.29-rc6 1/2] regulator: enumerate voltages (v2)
Date: Thu, 26 Feb 2009 16:10:24 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200902081037.06645.david-b@pacbell.net> <200902261328.41910.david-b@pacbell.net> <1235685488.31223.104.camel@vega.slimlogic.co.uk>
In-Reply-To: <1235685488.31223.104.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261610.24931.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Liam Girdwood wrote:
> 
> > What were the conflicts -- just offsets?
> > 
> > Your "-next" regulator tree seems to be missing a doc patch
> > you had asked for, maybe that's an issue.

And you seem to only have merged the header part of
the $SUBJECT patch, not the core.c parts ...

Everything gets kind of broken without the core.c
change!

- Dave


