Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZLBJKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZLBJKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbZLBJKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:10:54 -0500
Received: from bamako.nerim.net ([62.4.17.28]:52700 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbZLBJKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:10:52 -0500
Date: Wed, 2 Dec 2009 10:10:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michel =?ISO-8859-15?B?RORuemVy?= <michel@daenzer.net>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
Message-ID: <20091202101055.1ae7bf35@hyperion.delvare>
In-Reply-To: <1259744042.8188.397.camel@thor.local>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	<1259744042.8188.397.camel@thor.local>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Dec 2009 09:54:02 +0100, Michel Dänzer wrote:
> On Wed, 2009-12-02 at 09:19 +0100, Jean Delvare wrote: 
> > Michel, Darrick,
> > 
> > Apparently you are using the therm_adt746x driver, so maybe you would
> > be interested in testing and carrying the following patch. I've sent it
> > to Colin Leroy, who is listed as the maintainer for this driver, 1.5
> > month ago, but did not hear back.
> 
> The driver seems to load and work fine here (on a PowerBook5,8) with the
> patch, so feel free to add a Tested-By: line for me.

Will do, thanks.

BTW, I also have i2c-powermac patches queued for 2.6.33 if you want to
give them a try:

ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-powermac-*.patch

(Don't look for patch 5/6, it was broken so I discarded it.)

-- 
Jean Delvare
