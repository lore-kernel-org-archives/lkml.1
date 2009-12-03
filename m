Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZLCKYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZLCKYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZLCKYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:24:07 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:49553 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751953AbZLCKYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:24:06 -0500
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20091202101055.1ae7bf35@hyperion.delvare>
References: <20091202091951.5ec6bb83@hyperion.delvare>
	 <1259744042.8188.397.camel@thor.local>
	 <20091202101055.1ae7bf35@hyperion.delvare>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Dec 2009 11:24:06 +0100
Message-ID: <1259835846.5316.782.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-02 at 10:10 +0100, Jean Delvare wrote: 
> On Wed, 02 Dec 2009 09:54:02 +0100, Michel Dänzer wrote:
> > On Wed, 2009-12-02 at 09:19 +0100, Jean Delvare wrote: 
> > > Michel, Darrick,
> > > 
> > > Apparently you are using the therm_adt746x driver, so maybe you would
> > > be interested in testing and carrying the following patch. I've sent it
> > > to Colin Leroy, who is listed as the maintainer for this driver, 1.5
> > > month ago, but did not hear back.
> > 
> > The driver seems to load and work fine here (on a PowerBook5,8) with the
> > patch, so feel free to add a Tested-By: line for me.
> 
> Will do, thanks.
> 
> BTW, I also have i2c-powermac patches queued for 2.6.33 if you want to
> give them a try:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-powermac-*.patch
> 
> (Don't look for patch 5/6, it was broken so I discarded it.)

My PowerBook5,8 boots and works fine with all of these applied and
CONFIG_I2C_POWERMAC=y, so for all of them:

Tested-by: Michel Dänzer <michel@daenzer.net>


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer

