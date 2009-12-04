Return-Path: <linux-kernel-owner+w=401wt.eu-S1752139AbZLDJec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbZLDJec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbZLDJeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:34:31 -0500
Received: from bamako.nerim.net ([62.4.17.28]:53924 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZLDJea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:34:30 -0500
Date: Fri, 4 Dec 2009 10:34:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michel =?UTF-8?B?RMOkbnplcg==?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
Message-ID: <20091204103434.0a754925@hyperion.delvare>
In-Reply-To: <1259894454.2076.1246.camel@pasglop>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	<1259894454.2076.1246.camel@pasglop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, 04 Dec 2009 13:40:54 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2009-12-02 at 09:19 +0100, Jean Delvare wrote:
> > Michel, Darrick,
> > 
> > Apparently you are using the therm_adt746x driver, so maybe you would
> > be interested in testing and carrying the following patch. I've sent it
> > to Colin Leroy, who is listed as the maintainer for this driver, 1.5
> > month ago, but did not hear back.
> 
> I will take it.

Thanks.

> Basic rule is: CC to linuxppc-dev@lists.ozlabs.org ;-)
> 
> That way it gets picked up by patchwork and doesn't get lost. Even if it
> goes low on my priority list it will not be lost and I'll eventually
> pick it up.

I've sent it to linuxppc-dev@ozlabs.org on October 14th. This is the
address which is listed 22 times in MAINTAINERS. If it isn't correct,
then please update MAINTAINERS.

Also note that:
$ scripts/get_maintainer.pl --file drivers/macintosh/therm_adt746x.c 
Colin Leroy <colin@colino.net>
Grant Likely <grant.likely@secretlab.ca>
linux-kernel@vger.kernel.org
devicetree-discuss@lists.ozlabs.org

This lists Colin Leroy, who apparently doesn't exactly care about the
driver, but not linuxppc-dev@*ozlabs.org where you say patches should
be sent.

-- 
Jean Delvare
