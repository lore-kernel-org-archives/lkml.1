Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZLGWNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZLGWNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932821AbZLGWNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:13:06 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43182 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804AbZLGWNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:13:04 -0500
Date: Mon, 7 Dec 2009 14:13:02 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Jean Delvare <khali@linux-fr.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] therm_adt746x: Don't access non-existing register
Message-ID: <20091207221302.GU10295@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091202091951.5ec6bb83@hyperion.delvare> <1259744042.8188.397.camel@thor.local> <20091202101055.1ae7bf35@hyperion.delvare> <1259835846.5316.782.camel@thor.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1259835846.5316.782.camel@thor.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 11:24:06AM +0100, Michel Dänzer wrote:
> On Wed, 2009-12-02 at 10:10 +0100, Jean Delvare wrote: 
> > On Wed, 02 Dec 2009 09:54:02 +0100, Michel Dänzer wrote:
> > > On Wed, 2009-12-02 at 09:19 +0100, Jean Delvare wrote: 
> > > > Michel, Darrick,
> > > > 
> > > > Apparently you are using the therm_adt746x driver, so maybe you would
> > > > be interested in testing and carrying the following patch. I've sent it
> > > > to Colin Leroy, who is listed as the maintainer for this driver, 1.5
> > > > month ago, but did not hear back.
> > > 
> > > The driver seems to load and work fine here (on a PowerBook5,8) with the
> > > patch, so feel free to add a Tested-By: line for me.
> > 
> > Will do, thanks.
> > 
> > BTW, I also have i2c-powermac patches queued for 2.6.33 if you want to
> > give them a try:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/i2c-powermac-*.patch
> > 
> > (Don't look for patch 5/6, it was broken so I discarded it.)
> 
> My PowerBook5,8 boots and works fine with all of these applied and
> CONFIG_I2C_POWERMAC=y, so for all of them:
> 
> Tested-by: Michel Dänzer <michel@daenzer.net>

Patch set seems to work with CONFIG_I2C_POWERMAC=y just fine on my
PowerBook6,3, so

Tested-by: Darrick J. Wong <djwong@us.ibm.com>

--D
