Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbZGKWay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbZGKWay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 18:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZGKWaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 18:30:46 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:45992 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751268AbZGKWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 18:30:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CXzKwLWSE+H2amKU+g0siMelMPe3zlwNPU7BsnlST74D8co2mNK5hVd+Iq4g341yPwcny5mdaqfqdl4fDbqGWMWtwmoC2rDAv66jzwrjl2vL9FRlfJE5ukBtS1/3U5Zc4kP/kQbBPzvf0295vzFMWiwcWLaQpri8gNWD4g4tU1w=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: dkBfjuAVM1kgZMunoi79RvddILkGDOrON7F1II9HCys7b5VvEnJQiUAk_Ao3FVqoLi10URcrS_KT433.2.h0_di44KZXB8VCsGHn5_Fe_efgXdimlj1_yQ4Y_qe1xfXw0LWUHs_bAZ0GZAiC.xA7LKCblU8eMy75qHc4omueBFnxwJhrF45aBYdBf0k9n9DAdTAAJwCZejq4KnS1zHHN8Sk2dP9vHOVqCcncKMrg8H24W1f6KdWOZzk3ZY0MwBmayyBA5M3sgwlIA140
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Date: Sat, 11 Jul 2009 15:30:44 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <20090711170548.GC5205@suse.de> <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de> <1247345591-22643-38-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1247345591-22643-38-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907111530.44736.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 July 2009, Uwe Kleine-König wrote:
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.

Repeat -- NAK on this.  Use platform_driver_probe() instead.

I really don't like this series of patches.  It's just adding
bloat to kernels, in chunks of up to a page per patch.


