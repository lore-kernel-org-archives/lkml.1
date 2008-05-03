Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYECD3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYECD3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 23:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYECD3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 23:29:12 -0400
Received: from smtp109.sbc.mail.re2.yahoo.com ([68.142.229.96]:35928 "HELO
	smtp109.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756715AbYECD3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 23:29:12 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 23:29:11 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=VTi4KhEgoso40DNytMFImeGah6HWStRLrEKVU80i2P61zCB3tux3XXhKaIbYwddQch+RrZLcGvQIupRdrO39faoS7wg2BFItllY57ViJ+edOf0Ym9MpjwY1Y74EoRPexXzqXrF9HqUg6K7McsTLYa/DVXOmxCDrfL+vtq/CvnOc=  ;
X-YMail-OSG: ztTjME0VM1nF7_.z3W58EJPHt2JqrH.0x_CMexaJbXjivhswSwMPGQIItLVkVTVuDc8c2041cCvUeUTjdJ0Mod4wwYGK7tD816ED9nRBGTd6dHureROxO_GaQ9D3upO5eaM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Trent Piepho <tpiepho@freescale.com>
Subject: Re: [patch/rfc 2.6.25-git v2] gpio: sysfs interface
Date: Fri, 2 May 2008 20:05:19 -0700
User-Agent: KMail/1.9.6
Cc: lkml <linux-kernel@vger.kernel.org>, Ben Nizette <bn@niasdigital.com>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
References: <200804281239.51729.david-b@pacbell.net> <200804302135.56529.david-b@pacbell.net> <Pine.LNX.4.64.0805011249500.18441@t2.domain.actdsltmp>
In-Reply-To: <Pine.LNX.4.64.0805011249500.18441@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805022005.20015.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2008, Trent Piepho wrote:
> I've proposed many times that gpios that have been
> requested by anything be exported READ-ONLY automatically.  

Hmm, maybe that was buried in the volume of other stuff you
posted ... this is the first time I recall your mentioning
read-only exports.  Or limiting exports like that.  Certainly
no code I've seen from you worked like that.

What I recall was your original approach of exporting absolutely
everything -- hundreds of (potential) GPIOs, even pins that
were configured for other purposes.

I don't have any particular objection to exporting things
readonly.  Maybe you noticed the comment in my patches that
suggesting such an export mode might be useful.  But I'd
rather not export things that don't need exporting, and
bias things towards low per-gpio costs.

It's easy to add features later, if they turn out to be needed.
But removing interfaces is very hard ... which is another reason
I'm not very receptive to all those bells'n'whistles you propose.
