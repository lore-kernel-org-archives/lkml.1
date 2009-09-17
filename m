Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbZIQOVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbZIQOVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZIQOVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:21:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41300 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZIQOVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:21:23 -0400
Date: Thu, 17 Sep 2009 11:20:47 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] http://www.kernellabs.com/hg/~stoth/saa7164-merge
Message-ID: <20090917112047.1d803838@pedra.chehab.org>
In-Reply-To: <4AB23B6E.6050001@kernellabs.com>
References: <4AA08B01.30705@kernellabs.com>
	<20090917100258.2a5269d9@pedra.chehab.org>
	<4AB23B6E.6050001@kernellabs.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 17 Sep 2009 09:36:46 -0400
Steven Toth <stoth@kernellabs.com> escreveu:

> I should go back and check the other trees, if this field isn't required by the 
> i2c sub-system then I can remove it from a number of drivers. Of course, this 
> tree is fairly old and it may have already been done in the 23885 / cx88 / 
> au0828 tree's by the other devs. I'll look into this.

Jean Delvare did a work of cleaning up those fields. they aren't used inside
i2c. They are meant to be used inside the drivers, for the rare situations where an
i2c driver needs to know who is the i2c adapter where it is attaching.

> Regardless, I'll generate the i2c patch.
> 
> I also have another 2.6.31 related patch stacked up, once mkrufky's tree is also 
> merged. I'll issue both of these for merge later today.

Ok. It were already merged.



Cheers,
Mauro
