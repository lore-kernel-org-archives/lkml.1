Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZCBV2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZCBV2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZCBV2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:28:06 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43152 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbZCBV2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:28:03 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <49ABACA0.3090300@krogh.cc>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>
	 <49A6F39F.9040801@krogh.cc>
	 <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>
	 <49A6FEE2.90700@krogh.cc>
	 <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>
	 <49A70B24.6090706@krogh.cc>
	 <1235685269.6811.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>
	 <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>
	 <1235766936.7402.5.camel@localhost.localdomain> <49ABACA0.3090300@krogh.cc>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 13:27:57 -0800
Message-Id: <1236029277.7756.0.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 10:53 +0100, Jesper Krogh wrote:
> john stultz wrote:
> > Ok, so it seems ntp hasn't really had a chance to settle down, its only
> > made a 10ppm adjustment so far. NTPd will stop corrections at ~
> > +/-500ppm, so you're not at that bound yet, where things would be really
> > broken.
> > 
> > If the affected kernel isn't resetting in the logs anymore, I'd be
> > interested in what the new ppm value is.
> 
> After 20 hours.. its still resetting.
> Mar  2 10:43:24 quad12 ntpd[4416]: synchronized to 10.194.133.12, stratum 4
> Mar  2 10:50:37 quad12 ntpd[4416]: time reset -1.103654 s

So what's the "ntpdc -c kerninfo" output now?

thanks
-john


