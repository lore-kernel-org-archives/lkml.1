Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbZIJAB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbZIJAB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZIJAB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:01:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:56997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZIJABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=e9zIvgZLrO3VXuOW93WdeP/R4LaJnnq3UnwYBEbAqAAfab5eRl1XsMm3zKXe8LU7Ua
         v/MBH3WBWf/hB+cNyU4lItCqpVnQ7tJb5Px092pYGrViEFWC4X0DNIx90da2DQa+6M4M
         kWKW9w/cTrtA4zjp651MdOuVj4mEtYS1QQH0s=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: New fast(?)-boot results on ARM
Date: Thu, 10 Sep 2009 02:03:42 +0200
User-Agent: KMail/1.8.2
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
References: <20090814170228.GM13320@pengutronix.de> <20090904161626.GD3207@pengutronix.de> <20090909143354.GA15973@sig21.net>
In-Reply-To: <20090909143354.GA15973@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909100203.42235.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009 16:33, Johannes Stezenbach wrote:
> Sorry for slow reply.
> 
> On Fri, Sep 04, 2009 at 06:16:26PM +0200, Wolfram Sang wrote:
> > 
> > > Now that microcom is in Debian sid (thanks!), where can I find ptx_ts?
> > > It seems to be quite useful.
> > 
> > Back from the holidays, so here it is:
> > 
> > http://pengutronix.de/software/ptx_ts/index_en.html
> > 
> > Hope it can be useful...
> 
> Yes, it is.  Thanks!
> 
> BTW, some feedback about microcom:
> 
> - the choice of ^\ as an escape charater is unfortunate since that
>   is usually mapped to set SIGQUIT in the tty; a btter choice would
>   be ^] (like telnet) or ^A (like minicom)
> - typing the escape character immediate causes the menu to be displayed,
>   so one cannot send a break sequence for SysRq without cluttering up the screen
> 
> Would you take patches for that?

Sure.
--
vda
