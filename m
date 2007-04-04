Return-Path: <linux-kernel-owner+w=401wt.eu-S1751244AbXDDUvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbXDDUvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXDDUvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:51:24 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:33477 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751244AbXDDUvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:51:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LLbXKVus1zyYhAkl70G+t9UaEG6aEzOfAyU6EWLSNZfStMo0KD08sI25WryMzVY26Nrt9aArnwoXJ/+shiss85a48RwT3x5hPvZBCFgh+wY/KUR/ew+0ngLAOx/M5887zAM8L7HhrBCZCBhH9PV+j+ep17ewtmhRemCSEvKf7UA=  ;
X-YMail-OSG: kwJ_CmYVM1njMV51NCu.D8MCcpbo3n7DGc61bNvIZDyluUgS010exXdwRI5FBIa_yqGITMvBzw--
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Date: Wed, 4 Apr 2007 13:51:18 -0700
User-Agent: KMail/1.7.1
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
References: <11757099691323-git-send-email-tony@atomide.com> <20070404120025.4c5548dc.randy.dunlap@oracle.com> <Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704042205040.22282@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041351.19313.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 1:06 pm, Jan Engelhardt wrote:
> 
> On Apr 4 2007 12:00, Randy Dunlap wrote:
> >
> >> +static int __init fpga_init(void)
> >> +{
> >> +	if (machine_is_omap_h4()
> >> +			|| machine_is_omap_h3()
> >> +			|| machine_is_omap_h2()
> >> +			|| machine_is_omap_perseus2()
> >> +			)
> >
> >Perhaps there is nothing in CodingStyle for if () continuation
> >lines.  Looks like it is needed.  This is ETOOMUCHINDENTATION by
> >at least one tab.  Should be more like:
> >
> >+	if (machine_is_omap_h4()
> >+	    || machine_is_omap_h3()
> >+	    || machine_is_omap_h2()
> >+	    || machine_is_omap_perseus2())
> 
> My stance, || goes at EOL, and final ) not standalone:

You are still violating the "only TABs used for indent" rule.


> 	if (foo ||
> 	  bar ||
> 	  baz ||
> 	  etc)
> 		do_something;
> 
> 
> 
> Jan
> -- 
> 
