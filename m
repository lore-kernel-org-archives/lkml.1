Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702Ab0AZGnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0AZGnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 01:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903Ab0AZGnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 01:43:12 -0500
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:36455 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752180Ab0AZGnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 01:43:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=6Fln+2VM9QJZOalJCGUuG2anoGaUejh4ytcrMeGDKGUDXfHwcjVufz0WpvRY5Gt79aAAqi5PUP/SsDDGTOg1ZhybKQeBZV3GJWBSYl6WZPFNMblCFsd4oTzGyIJqQx3myd4n/COgr6JmBdHcfBnKR40/Zoqn0v8SSD4RK4lSEzI=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: FrKYwP8VM1lx8z_6KbQ_PRQfQX.CWbSII0I0wjKwzRoJezclPY4mfMHLa0gORLhjQ0raJ1lnyZ67z3rzQeCp1D_31IiFjCi6wl5A3wM7th5RQ.78lGJgFIZqj2Xp987F4TMWrvNJxy4cuYYFaez_uFAp0o44y1sXRKZqhl.UbIehVBrlGF9Fy.CtL7xWFat05wuPwyQHaKoiO5HbWOtSLWE7sJMSB7M1raFpbB7cF7NHGgY.7tSH4FpZNrmlpBDE
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 4/4] powerpc/mcu_mpc8349emitx: Remove OF GPIO handling stuff
Date: Mon, 25 Jan 2010 22:43:04 -0800
User-Agent: KMail/1.9.10
Cc: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20100125180957.GA5380@oksana.dev.rtsoft.ru> <20100125181114.GD13805@oksana.dev.rtsoft.ru>
In-Reply-To: <20100125181114.GD13805@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201001252243.04888.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Anton Vorontsov wrote:
> With the new OF GPIO infrastructure it's much easier to handle I2C
> GPIO controllers, i.e. now drivers don't have to deal with the
> OF-specific bits.

Good, that's how it should have been done in the first place.  :)

Of course, there's still the question of how to get driver-specific
configuration data into the driver...
