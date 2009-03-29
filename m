Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbZC2TKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbZC2TKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZC2TKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:10:30 -0400
Received: from n5a.bullet.mud.yahoo.com ([209.191.126.232]:44519 "HELO
	n5a.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751041AbZC2TK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:10:29 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 15:10:29 EDT
X-Yahoo-Newman-Id: 538111.46173.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xhdy3YgYTgW0eoDUHHn1y/6wr+eAB99L9HgbIXROqkFBp5fGhp/a7Iv7SISILeU4pT9TT/TUo6pR4uiEmZFp78Q3bcfRVlsajRnvNf79wbG6lnPvq+8ZnZFtkralsj0HcRjCwBR2HPi+RbY2zVmDTKNEmlXOkn97UVNQ3U8waWk=  ;
X-YMail-OSG: gXpt6PsVM1nhwzgBESQjrCw8sontjSlbCZgx3rnQpfrHGxUeduygFiv1iSIuXhvlZ89Jca0S5BFye9SkekylmNNg49dNj_.C8MnhpDDkU8l2s9qQgX7hc2Z5J.vPxwqj9SoYteKB1EUM6P91lnEpCZ3iCb_daYIXkLi5cTpCKl2GYmDb25ILUI4vz9IowzoKj0ajutgIbaysDUy19BAaMaONcXKbfUURzQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 34/58] move omap_rng's probe function to .devinit.text
Date: Sun, 29 Mar 2009 12:03:53 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Patrick McHardy <kaber@trash.net>, Jan Engelhardt <jengelh@gmx.de>,
       Michael Buesch <mb@bu3sch.de>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-34-git-send-email-u.kleine-koenig@pengutronix.de> <20090329074731.GD11735@gondor.apana.org.au>
In-Reply-To: <20090329074731.GD11735@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903291203.54301.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 March 2009, Herbert Xu wrote:
> On Sat, Mar 28, 2009 at 12:26:55AM +0100, Uwe Kleine-König wrote:
> > A pointer to omap_rng_probe is passed to the core via
> > platform_driver_register and so the function must not disappear when the
> > .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> > unbinding and binding a device to the driver via sysfs will result in an
> > oops as does a device being registered late.
> > 
> > An alternative to this patch is using platform_driver_probe instead of
> > platform_driver_register plus removing the pointer to the probe function
> > from the struct platform_driver.

Reminder:  we're expecting such an updated version,
to replace this one.


> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Patrick McHardy <kaber@trash.net>
> > Cc: Jan Engelhardt <jengelh@gmx.de>
> > Cc: Michael Buesch <mb@bu3sch.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> Applied to cryptodev.  Thanks!
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
> 



