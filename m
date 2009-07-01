Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZGACgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZGACgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZGACg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:36:29 -0400
Received: from n74.bullet.mail.sp1.yahoo.com ([98.136.44.186]:24545 "HELO
	n74.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751016AbZGACg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:36:28 -0400
X-Yahoo-Newman-Id: 182987.29075.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LjfbasPUal8qZcHdz/0GP2MgF7LfkGlFmR+pANp4i4ki6Q1vnwom/hQageQGJ+xnNLlMoiTDs6pBm/o5fRVZGfsbesFcwdgAF2JGYIDdrfaNGAsBDNU+E0I4J+l2RbHs9O2n4bzFiwIKpENaU73QJRz+HgMCgwfPgd24/TsQQUw=  ;
X-YMail-OSG: ..UbwHkVM1mhZfSh5_.Bkiu1w9BL90tJznAv2fxSQcv7gMVTf1Q6nb2G058auSFRr0LdJLlcpEb4yFNDom8H3IPpIoOE6Hd0Z_VHjrvkkNZx4mUmFGx9Ozd10nur0GboVdhV6XxbfUEsYOswN2Ara75uI0MtvPNAFJjdSTKLrSsH7nOZdj_a15Qk7AQ6ZSbp9O3GZ510nMagLK47nqzORG987L_2WM0BCSvaFr11omClQkcV32GmuWswFKcvKnJA0BIgOdhYDWZU3a7YYXlhsIq37JfWLwTqQlthsbPGWMDF0Lw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
Date: Tue, 30 Jun 2009 19:36:20 -0700
User-Agent: KMail/1.9.10
Cc: Eric Miao <eric.y.miao@gmail.com>, Daniel Ribeiro <drwyrm@gmail.com>,
       Pierre Ossman <pierre@ossman.eu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "openezx-devel" <openezx-devel@lists.openezx.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       "linux-arm-kernel" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <1246057668.10360.316.camel@brutus> <4A482E56.1070604@gmail.com> <20090629094311.GD11855@sirena.org.uk>
In-Reply-To: <20090629094311.GD11855@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906301936.20818.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Mark Brown wrote:
> At the minute the regulator API actually copes pretty well with this -
> the only problem I'm aware of is with drivers like the MMC driver which
> require exclusive control of the regulator.

Which is a fairly typical situation for power-aware drivers.

Which belies your claim that the regulator API "copes pretty well".
It'd be more accurate to say "broken-as-designed", since you have
rejected numerous attempts to fix this, yet not fixed it yourself.


> With other drivers the core 
> API can clean up after startup and the drivers never need to worry about
> fixing things up.

MMC isn't particularly unusual.  It's just the first place this
type problem tends to come up.  Expect more such problelms as
folkl actually try to *use* the regulator framework.



