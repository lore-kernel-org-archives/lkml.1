Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbZGKW14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbZGKW14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZGKW1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:27:49 -0400
Received: from n18.bullet.mail.mud.yahoo.com ([68.142.206.145]:31327 "HELO
	n18.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751276AbZGKW1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:27:48 -0400
X-Yahoo-Newman-Id: 772233.91361.bm@omp422.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FJojgAHQ7P4k4vN99o4hICHl4bef6LegEKpHRdOkDLNK/Im7phVh4Ss1DHKSM3CFpEPD2AW6sB52m5r8kT9ca4xUv59Fxs+OJdoyJtw9NIPCLW7VWWTit714ObzXFw5Gu9bi2YXVzPn+TcGRwaM8/jvATXcsDXpK8W7NQmzTdh4=  ;
X-YMail-OSG: ycLTyBcVM1lTIKn93_5teYJeFFZa60aRbgnyJWhX8yi7Era_aRvyRdF5MKXt8WiQRM5M2BKfUtb3C4iPpy30N285q9UCxPIT1KmWVG0Jz0r.J5NoFPlC0V62UiLbsG8o6CrR6XOehdcnmUbAYdOTdzu3FUAHMafKX2cSRmTXUCgJU5GNhLtkCl1r4JAVggd2RMwMeCsPVQicqq3IZMTuvC55GGQuLVCCUPdrQ9qTfLWGsKRREVSWJ4AbhK4YBwOkLoSMaH0KVKZ2aFzB
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] move at91_ether's probe function to .devinit.text
Date: Sat, 11 Jul 2009 15:27:46 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jeff Garzik <jgarzik@redhat.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907111527.46441.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 July 2009, Uwe Kleine-König wrote:
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

And that's the preferred fix I was expecting to see.

NAK on this version.


