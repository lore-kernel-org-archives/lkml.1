Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbYGDQ6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbYGDQ6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbYGDQwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:52:14 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:45812 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759892AbYGDQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:52:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iv+k1SXQW7uQGYt7pfBnuN1FsoGkq4UhxBE2FU+hFLvoEz/XOsuw4q4sVoPOsBczTdyth5rnF+q052gZtOchDfa+p406DMoycgddJUR4gs4sbFOEb1n/lWUW3vSQwEnM2wgJFxdc3HNF7IaSkHvI3CI6MjbdK7OsUkBGdH7EQT0=  ;
X-YMail-OSG: cDdmu70VM1lTj0pNkElgfIdfhc9d8u_8v.xu97JiijPZbWWq12PqMgIONu27XDr.0iQS7dmc2Q.wieHk1_JOA9BJmFHxqaXfEM0ZcWd6Jw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] fix build error of driver/mfd/tc6393xb.c
Date: Fri, 4 Jul 2008 09:52:10 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <s5hiqvlc2ut.wl%tiwai@suse.de> <20080704132234.GA4576@doriath.ww600.siemens.net> <s5hd4ltlpgl.wl%tiwai@suse.de>
In-Reply-To: <s5hd4ltlpgl.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807040952.10401.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2008, Takashi Iwai wrote:
> Then HAVE_GPIO_LIB selects GENERIC_GPIO.  Right now, it's a missing
> dependency.

Right.


> > Also linux/gpio.h don't have anything in common with HAVE_GPIO_LIB.
> 
> That's another side of the problem.

Not a problem at all.  One is the interface.  Another is one
of several valid implementations ... the only currently
providing an infrastructure allowing providers like tc6393xb
to plug in as easily as SOC-native providers.

- Dave


