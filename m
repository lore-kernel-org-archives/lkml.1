Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZFZJoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZFZJoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZFZJoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:44:07 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38593 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZFZJoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:44:06 -0400
Subject: Re: da9030: ldo11 ignores disable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>,
       mike.rapoport@gmail.com, eric miao <eric.y.miao@gmail.com>
In-Reply-To: <4A439A2B.2020706@cam.ac.uk>
References: <4A439A2B.2020706@cam.ac.uk>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 10:44:05 +0100
Message-Id: <1246009446.30631.27.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 15:39 +0000, Jonathan Cameron wrote:
> Hi All,
> 
> Whilst testing a regulator machine config I've run into a weird issue.
> 
> The preliminary data sheet I have suggests that there are two enable
> registers
> for ldo11 but neither rctl22 or rctl11 seems to have any effect (on
> their own
> or both cleared together). I can change the voltage just fine, but not
> actually turn it off.
> 
> Anyone come across this problem or have any idea what is going on?

I've come across something similar in the past with two enable bits
causing I2C register cache coherency issues. The cache bits became out
of sync with reality and stopped some I2C writes happening.

Another option is that your hardware config doesn't allow ldo11 to be
disabled ?

HTH

Liam

